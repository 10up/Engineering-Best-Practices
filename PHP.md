# Performance

Writing performant code is absolutely critical especially at the enterprise level. There are a number of strategies and best practices we must employ to ensure our code is optimized for high-traffic situations.

## Efficient Database Queries

When querying the database in WordPress you should generally use a ```WP_Query``` object. ```WP_Query``` objects take a number of useful arguments and do things behind-the-scenes that other database access methods such as ```get_posts()``` do not. You should read the ```WP_Query``` codex page thoroughly. Here are a few key points/rules:

* Do not use ```posts_per_page => -1```. This is a performance hazard. What if we have 100,000 posts? This could crash the site. If you are writing a widget for example and just want to grab all of a custom post type, use a reasonable number like 500.

```php
new WP_Query( array(
  'posts_per_page' => 500,
));
```

* Do not use ```$wpdb``` or ```get_posts()``` unless you have good reason. ```WP_Query``` actually calls ```get_posts()```; calling ```get_posts()``` directly bypasses a number of filters. Not sure whether you need these things or not? You probably don't.
* If you don't plan to paginate query results, always pass ```no_found_rows => true``` to ```WP_Query```. This will tell WordPress not to run ```SQL_CALC_FOUND_ROWS``` on the SQL query drastically speeding up your query. ```SQL_CALC_FOUND_ROWS``` calculates the total number of rows in your query which is required to know the total amount of "pages" for pagination.

```php
new WP_Query( array(
  'no_found_rows' => true,
));
```

* A taxonomy is a tool that lets us group or classify posts. Post meta lets us store unique information about specific posts. As such the way post meta is stored does not facilitate efficient post lookups. Generally, looking up posts by post meta should be avoided (sometimes it can't). If you have to use one, make sure that it's not the main query and that it's cached.
* Passing ```cache_results => false``` to ```WP_Query``` is usually not a good idea. If ```cache_results => true``` (which is true by default if you have caching enabled and an object cache setup), ```WP_Query``` will cache the posts found among other things. It makes sense to use ```cache_results => false``` in rare situations (possibly WP-CLI commands).
* Multi-dimensional queries should be avoided. 3-dimensional queries should almost always be avoided. Examples of multi-dimensional queries are querying for posts based on terms across multiple taxonomies or multiple post meta keys. Each extra dimension of a query joins an extra database table. Instead, query by the minimum number of dimensions possible and use PHP to facilitate filtering out results you don't need. Here is an example of a 2-dimensional query:

```php
new WP_Query( array(
  'category_name' => 'cat-slug',
  'tag' => 'tag-slug',
));
```

## Caching

Caching is simply the act of storing computed data somewhere for later use and is an incredibly important concept in WordPress. There are different ways to employ caching. Often we utilize multiple methods.

### The "Object Cache"
Object caching is the act of caching data or objects for later use. In the context of WordPress, we prefer to cache objects in memory so we can retrieve them quickly.

In WordPress the object cache functionality provided by ```WP_Object_Cache``` and the Transient API are great solutions for improving performance on long running queries, complex functions or the like.

On a regular WordPress install the difference between transients and the object cache is that transients are persistent and would write to the options table while the object cache only persists for the particular page load.

On environments with a persistent caching mechanism (eg. Memcache) enabled, the transient functions become wrappers for the normal ```WP_Object_Cache``` functions. The objects are identically stored in the object cache and will be available across page loads.

However, as the objects are stored in memory you need to consider that these objects can be cleared at any time and your code must be constructed in a way that it would not rely on the objects being in place.

This means we always need to ensure that we check for the existence of a cached object and be ready to generate it in case it's not available. Here is an example:

```php
function get_top_commented_posts() {
    // Check for the top_commented_posts key in the top_posts group
    $top_commented_posts = wp_cache_get( 'top_commented_posts', 'top_posts' );
    // if nothing is found, build the object.
    if ( false === $top_commented_posts ) {
        // grab the top 10 most commented posts
        $top_commented_posts = new WP_Query( 'orderby=comment_count&posts_per_page=10');
        if ( !is_wp_error( $top_commented_posts ) && $top_commented_posts->have_posts() ) {
            // cache the whole WP_Query object in the cache and store it for 5 minutes (300 secs)
            wp_cache_set( 'top_commented_posts', $top_commented_posts, 'top_posts', 300 )
        }
    }
    return $top_commented_posts;
}
```


In this example we would check the cache for an object with the 10 most commented posts and would generate the list in case the object is not in the cache yet. Generally, calls to ```WP_Query``` other than the main query should be cached.

As we cache the content for 300 seconds, we limit the query execution to one time every 5 minutes which is nice.

However, the cache rebuild in this example would always be triggered by a visitor who would hit a stale cache which will increase the page load time for the visitors and under high traffic conditions. This can cause race conditions when a lot of people hit a stale cache for a complex query at the same time. In the worst case this could cause queries at the database server to pile up causing replication, lag, or worse.

That said, a relatively easy solution for this problem is to make sure that your users would ideally always hit a primed cache. To do this you need to think about the conditions that need to be met to make the cached value invalid. In our case this would be the change of a comment.

The easiest hook we could identify that would be triggered for any of this actions would be wp_update_comment_count set as ```do_action( 'wp_update_comment_count', $post_id, $new, $old )```.

With this in mind we can change our function so that the cache would always be primed when this action is triggered.

Here is how it's done:

```php
// Force a refresh of top commented posts when we have a new comment count
add_action( 'wp_update_comment_count', 'refresh_top_commented_posts', 10, 3 );
function refresh_top_commented_posts( $post_id, $new, $old ) {
    // force the cache refresh for top commented posts
    get_top_commented_posts( $force_refresh = true );
}

function get_top_commented_posts( $force_refresh = false ) {
    // Check for the top_commented_posts key in the top_posts group
    $top_commented_posts = wp_cache_get( 'top_commented_posts', 'top_posts' );
    // if nothing is found, build the object.
    if ( true === $force_refresh || false === $top_commented_posts ) {
        // grab the top 10 most commented posts
        $top_commented_posts = new WP_Query( 'orderby=comment_count&posts_per_page=10');
        if ( !is_wp_error( $top_commented_posts ) && $top_commented_posts->have_posts() ) {
            // In this case we don't need a timed cache expiration
            wp_cache_set( 'top_commented_posts', $top_commented_posts, 'top_posts' )
        }
    }
    return $top_commented_posts;
}
```

With this implementation you can keep the cache object forever and don't need to add an expiration for the object as you would create a new cache entry whenever it is required.  Just keep in mind that some external caches (like Memcache) can invalidate cache objects without any input from WordPress. For that reason, we always need the code that repopulates the cache available.

In some cases it might be necessary to create multiple objects depending on the parameters a function is called with. In these cases it's usually a good idea to create a cache key which includes a representation of the variable parameters. A simple solution for this would be appending a md5 hash of the serialized parameters to the key name.

### Page Caching

Page caching in the context of web development refers to storing a requested locations entire output to serve in the event of subsequent requests to the same location.

[Batcache](https://wordpress.org/plugins/batcache) is a WordPress plugin that uses cache (usually Memcache in the context of WordPress) to store and serve rendered pages. It can also optionally cache redirects. It's not as fast as some other caching plugins, but it can be used where file-based caching is not practical or not desired.

Batcache is aimed at preventing a flood of traffic from breaking your site. It does this by serving old (max 5 min) pages to new users. This reduces the demand on the web server CPU and the database. It also means some people may see a page that is a few minutes old, however this only applies to people who have not interacted with your web site before. Once they have logged in or left a comment they will always get fresh pages.

Although this plugin has a lot of benefits, it also has a couple of code design requirements. As the rendered HTML of your pages might be cached you cannot rely on server side logic related to ```$_SERVER```, ```$_COOKIE``` or other values that are unique to a particular user. You can however implement cookie or other user based logic on the front-end (eg. with JavaScript).

As Batcache does not cache calls for URLs with query strings or logged in users (based on WordPress login cookies), you will need to make sure that your application design uses pretty urls to really benefit from this caching layer.

There are other page caching solutions such as W3 Total Cache. We generally do not use other page caching plugins for a variety of reasons.

## Appropriately Storing Data

Utilizing built-in WordPress API's we can store data in a number of ways. We can store data using options, post meta, post types, object cache, and taxonomy terms. There are a number of performance considerations for each WordPress storage vehicle:

* [Options](http://codex.wordpress.org/Options_API). The options API is a simple key-value storage system backed by a MySQL table. This API is mean't to store things like settings and not variable amounts of data.
* [Post Meta or Custom Fields](http://codex.wordpress.org/Custom_Fields). Post meta is an API mean't for storing information specific to a post. For example, if we had a custom post type, "Product", "serial number" would be information appropriate for post meta. Because of this, it usually doesn't make sense to search for groups of posts based on post meta
* [Taxonomies and Terms](http://codex.wordpress.org/Taxonomies). Taxonomies are essentially groupings. If we have a "classification" that spans multiple posts, it is a good fit for a taxonomy term. For example, if we had a custom post type, "Product", "manufacturer" would be a good term since multiple products could have the same manufacturer. Taxonomy terms can be efficiently searched across as opposed to post meta.
* Posts. WordPress has the notion of "post types". "Post" is a post type which can be confusing. We can register custom post types to store all sorts of interesting pieces of data. If we have a variable amount of data to store such as a product, a custom post type might be a good fit.
* Object Cache. See caching section.

## Database Writes

Writing information to the database is at the core of any website we build. Here are some tips:

* Generally, do not write to the database on frontend pages as doing so can result in major performance issues and race conditions.

* When multiple threads (or page requests) read or write to a shared location in memory and the order of those read or writes is unknown, you have what is known as a [race condition](http://en.wikipedia.org/wiki/Race_condition).

* Store information in the correct place. See "Appropriately Storing Data" section.

* Certain options are "autoloaded" or put into the object cache on each page load. When creating or updating options, you can pass an ```$autoload``` argument to ```add_option()```. If your option is not going to get used often, it probably shouldn't be autoloaded. Unfortunately, ```update_option()``` automatically sets autoload to true so you have to use a combination of ```delete_option()``` and ```add_option()``` to accomplish this.

# Security

Security in the context of web development is a huge topic. This section only addresses what we can do at the server-side code level.

##Input Validation and Sanitization

To validate is to ensure the data you've requested of the user matches what they've submitted. There are several core methods you can use for input validation; usage obviously depends on the type of fields you'd like to validate.

Any non-static data that is stored in the database must be validated or sanitized. Not doing so can result in creating potential security vulnerabilities. For example, let's validate an integer we are storing in post meta:

```php
if ( ! empty( $_POST['user_id'] ) ) {
    update_post_meta( $post_id, 'key', absint( $_POST['user_id'] ) );
}
```

```$_POST['user_id']``` is validated using ```absint()``` which ensures an integer >= 0. Without validation ```$_POST['user_id']``` could be used maliciously to inject harmful code/data into the database. Here is another example where we sanitize a text field to be stored in the database:

```php
if ( ! empty( $_POST['special_heading'] ) ) {
    update_option( 'option_key', sanitize_text_field( $_POST['special_heading'] ) );
}
```

Again, since ```update_option()``` is storing in the database we must validate or sanitize. Here we use the sanitize text field function which is appropriate for general text fields.

WordPress has a number of [validation and sanitization functions built-in](http://codex.wordpress.org/Validating_Sanitizing_and_Escaping_User_Data#Validating:_Checking_User_Input). Sometimes it can be confusing as to which is the most appropriate for a given situation. Sometimes it's even appropriate for us to write our own sanitization and validation methods.

## Escape Output

To escape is to take the data you may already have and help secure it prior to rendering it for the end user. Any non-static data outputted to the browser must be escaped. WordPress has a number of core functions we can leverage for escaping. Here are some simple examples:

```php
<div>
    <?php echo esc_html( get_post_meta( $post_id, 'key', true ) ); ?>
</div>
```

```esc_html()``` ensures output does not contain any html thus preventing JavaScript injection and layout breaks. Here is another example:

```php
<script>
if ( document.cookie.indexOf( 'cookie_key' ) >= 0 ) {
    document.getElementById( 'test' ).getAttribute( 'href' ) = '<?php echo esc_js( get_post_meta( $post_id, 'key', true ) ); ?>';
}
</script>
```

```esc_js()``` ensures that whatever is returned is ok to be printed within a JavaScript string.

If we need to escape such that HTML is permitted (but not harmful JavaScript), we usually have to use the ```wp_kses_*``` functions:

```php
<div>
    <?php echo wp_kses_post( get_post_meta( $post_id, 'meta_key', true ) ); ?>
</div>
```

```wp_kses_*``` functions should be used sparingly as they have bad performance due to a large number of regular expression matching attempts. If you find yourself using ```wp_kses_*```, it's worth evaluating what you are doing as whole. Are you providing a meta box for users to enter arbitrary HTML? Perhaps, you can add the HTML programmatically and provide the user with a few options to customize. If you do have to use wp_kses_*, output should be cached for as long as possible.

WordPress has a number of functions built-in for [escaping output](http://codex.wordpress.org/Validating_Sanitizing_and_Escaping_User_Data#Escaping:_Securing_Output).

# Code Style

We follow the [WordPress coding standards](http://make.wordpress.org/core/handbook/coding-standards/php/).

# Unit and Integration Testing

Unit testing is the automated testing of units of source code against assumptions. The goal of unit testing is to write test cases with assumptions that test if a unit of code is truly working as intended. If an assumption fails, a potential issue is exposed, and code needs to be revised.

By definition unit tests do not have dependencies on outside systems; in other words only your code (a single unit of code) is being tested. Integration testing works similarly to unit tests but assumptions are tested against systems of code, moving parts, or an entire application. The phrases unit testing and integration testing are often misused to reference one another especially in the context of WordPress

At 10up, we generally employ unit and/or integration tests only when building applications that are meant to be distributed. Building tests for client themes does usually not offer a huge amount of value (there are of course exceptions to this). When we do write tests, we use PHPUnit which is a WordPress standard.

Read more at the [PHPUnit homepage](https://phpunit.de/) and [automated testing for WordPress](http://make.wordpress.org/core/handbook/automated-testing/)

# Libraries and Frameworks

Generally, we do not use PHP frameworks or libraries that do not live within WordPress for general theme development. WordPress API's provide us with 99% of the functionality we need from database management to sending emails. There are frameworks and libraries we use for themes and plugins that are being distributed or open-sourced to the public such as PHPUnit.
