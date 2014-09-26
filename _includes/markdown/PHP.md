<h3 id="php-performance">Performance</h3>

Writing performant code is absolutely critical especially at the enterprise level. There are a number of strategies and best practices we must employ to ensure our code is optimized for high-traffic situations.

#### Efficient Database Queries

When querying the database in WordPress you should generally use a ```WP_Query``` (see [codex](http://codex.wordpress.org/Class_Reference/WP_Query)) object. ```WP_Query``` objects take a number of useful arguments and do things behind-the-scenes that other database access methods such as ```get_posts()``` do not. You should read the ```WP_Query``` codex page thoroughly. Here are a few key points/rules:

* Do not use ```posts_per_page => -1```. This is a performance hazard. What if we have 100,000 posts? This could crash the site. If you are writing a widget, for example, and just want to grab all of a custom post type, determine a reasonable upper limit for your situation.

```php
<?php
new WP_Query( array(
  'posts_per_page' => 500,
));
?>
```

* Do not use ```$wpdb``` or ```get_posts()``` unless you have good reason. ```WP_Query``` actually calls ```get_posts()```; calling ```get_posts()``` directly bypasses a number of filters. Not sure whether you need these things or not? You probably don't.
* If you don't plan to paginate query results, always pass ```no_found_rows => true``` to ```WP_Query```. This will tell WordPress not to run ```SQL_CALC_FOUND_ROWS``` on the SQL query drastically speeding up your query. ```SQL_CALC_FOUND_ROWS``` calculates the total number of rows in your query which is required to know the total amount of "pages" for pagination.

```php
<?php
new WP_Query( array(
  'no_found_rows' => true,
));
?>
```

* A [taxonomy](http://codex.wordpress.org/Taxonomies) is a tool that lets us group or classify posts. [Post meta](http://codex.wordpress.org/Custom_Fields) lets us store unique information about specific posts. As such the way post meta is stored does not facilitate efficient post lookups. Generally, looking up posts by post meta should be avoided (sometimes it can't). If you have to use one, make sure that it's not the main query and that it's cached.
* Passing ```cache_results => false``` to ```WP_Query``` is usually not a good idea. If ```cache_results => true``` (which is true by default if you have caching enabled and an object cache setup), ```WP_Query``` will cache the posts found among other things. It makes sense to use ```cache_results => false``` in rare situations (possibly WP-CLI commands).
* Multi-dimensional queries should be avoided. 3-dimensional queries should almost always be avoided. Examples of multi-dimensional queries are querying for posts based on terms across multiple taxonomies or multiple post meta keys. Each extra dimension of a query joins an extra database table. Instead, query by the minimum number of dimensions possible and use PHP to facilitate filtering out results you don't need. Here is an example of a 2-dimensional query:

```php
<?php
new WP_Query( array(
  'category_name' => 'cat-slug',
  'tag' => 'tag-slug',
));
?>
```

#### Caching

Caching is simply the act of storing computed data somewhere for later use and is an incredibly important concept in WordPress. There are different ways to employ caching. Often we utilize multiple methods.

##### The "Object Cache"

Object caching is the act of caching data or objects for later use. In the context of WordPress, we prefer to cache objects in memory so we can retrieve them quickly.

In WordPress the object cache functionality provided by ```WP_Object_Cache``` (see [codex](http://codex.wordpress.org/Class_Reference/WP_Object_Cache)) and the Transient API are great solutions for improving performance on long running queries, complex functions or the like.

On a regular WordPress install the difference between transients and the object cache is that transients are persistent and would write to the options table while the object cache only persists for the particular page load.

On environments with a persistent caching mechanism (i.e. [Memcache](http://memcached.org/)) enabled, the transient functions become wrappers for the normal ```WP_Object_Cache``` functions. The objects are identically stored in the object cache and will be available across page loads.

However, as the objects are stored in memory you need to consider that these objects can be cleared at any time and your code must be constructed in a way that it would not rely on the objects being in place.

This means we always need to ensure that we check for the existence of a cached object and be ready to generate it in case it's not available. Here is an example:

```php
<?php
function prefix_get_top_commented_posts() {
    // Check for the top_commented_posts key in the top_posts group
    $top_commented_posts = wp_cache_get( 'prefix_top_commented_posts', 'top_posts' );

    // if nothing is found, build the object.
    if ( false === $top_commented_posts ) {
        // grab the top 10 most commented posts
        $top_commented_posts = new WP_Query( 'orderby=comment_count&posts_per_page=10');

        if ( ! is_wp_error( $top_commented_posts ) && $top_commented_posts->have_posts() ) {
            // cache the whole WP_Query object in the cache and store it for 5 minutes (300 secs)
            wp_cache_set( 'prefix_top_commented_posts', $top_commented_posts, 'top_posts', 300 )
        }
    }

    return $top_commented_posts;
}
?>
```


In this example we would check the cache for an object with the 10 most commented posts and would generate the list in case the object is not in the cache yet. Generally, calls to ```WP_Query``` other than the main query should be cached.

As we cache the content for 300 seconds, we limit the query execution to one time every 5 minutes which is nice.

However, the cache rebuild in this example would always be triggered by a visitor who would hit a stale cache which will increase the page load time for the visitors and under high traffic conditions. This can cause race conditions when a lot of people hit a stale cache for a complex query at the same time. In the worst case this could cause queries at the database server to pile up causing replication, lag, or worse.

That said, a relatively easy solution for this problem is to make sure that your users would ideally always hit a primed cache. To do this you need to think about the conditions that need to be met to make the cached value invalid. In our case this would be the change of a comment.

The easiest hook we could identify that would be triggered for any of this actions would be ```wp_update_comment_count``` set as ```do_action( 'wp_update_comment_count', $post_id, $new, $old )```.

With this in mind we can change our function so that the cache would always be primed when this action is triggered.

Here is how it's done:

```php
<?php
function prefix_refresh_top_commented_posts( $post_id, $new, $old ) {
    // force the cache refresh for top commented posts
    prefix_get_top_commented_posts( $force_refresh = true );
}
add_action( 'wp_update_comment_count', 'prefix_refresh_top_commented_posts', 10, 3 );

function prefix_get_top_commented_posts( $force_refresh = false ) {
    // Check for the top_commented_posts key in the top_posts group
    $top_commented_posts = wp_cache_get( 'prefix_top_commented_posts', 'top_posts' );

    // if nothing is found, build the object.
    if ( true === $force_refresh || false === $top_commented_posts ) {
        // grab the top 10 most commented posts
        $top_commented_posts = new WP_Query( 'orderby=comment_count&posts_per_page=10');

        if ( ! is_wp_error( $top_commented_posts ) && $top_commented_posts->have_posts() ) {
            // In this case we don't need a timed cache expiration
            wp_cache_set( 'prefix_top_commented_posts', $top_commented_posts, 'top_posts' )
        }
    }
    return $top_commented_posts;
}
?>
```

With this implementation you can keep the cache object forever and don't need to add an expiration for the object as you would create a new cache entry whenever it is required.  Just keep in mind that some external caches (like Memcache) can invalidate cache objects without any input from WordPress. For that reason, we always need the code that repopulates the cache available.

In some cases it might be necessary to create multiple objects depending on the parameters a function is called with. In these cases it's usually a good idea to create a cache key which includes a representation of the variable parameters. A simple solution for this would be appending a md5 hash of the serialized parameters to the key name.

##### Page Caching

Page caching in the context of web development refers to storing a requested locations entire output to serve in the event of subsequent requests to the same location.

[Batcache](https://wordpress.org/plugins/batcache) is a WordPress plugin that uses cache (usually Memcache in the context of WordPress) to store and serve rendered pages. It can also optionally cache redirects. It's not as fast as some other caching plugins, but it can be used where file-based caching is not practical or not desired.

Batcache is aimed at preventing a flood of traffic from breaking your site. It does this by serving old (max 5 min) pages to new users. This reduces the demand on the web server CPU and the database. It also means some people may see a page that is a few minutes old, however this only applies to people who have not interacted with your web site before. Once they have logged in or left a comment they will always get fresh pages.

Although this plugin has a lot of benefits, it also has a couple of code design requirements. As the rendered HTML of your pages might be cached you cannot rely on server side logic related to ```$_SERVER```, ```$_COOKIE``` or other values that are unique to a particular user. You can however implement cookie or other user based logic on the front-end (eg. with JavaScript).

As Batcache does not cache calls for URLs with query strings or logged in users (based on WordPress login cookies), you will need to make sure that your application design uses pretty urls to really benefit from this caching layer.

There are other page caching solutions such as W3 Total Cache. We generally do not use other page caching plugins for a variety of reasons.

##### AJAX Endpoints

AJAX stands for Asynchronous JavaScript and XML. Often we use JavaScript on the client-side to ping endpoints for things like infinite scroll.

WordPress [provides an API](http://codex.wordpress.org/AJAX_in_Plugins) to register AJAX endpoints on ```wp-admin/admin-ajax.php```. However, WordPress does not cache queries within the administration panel for obvious reasons. Therefore, if you send requests to an admin-ajax.php endpoint, you are bootstrapping WordPress and running uncached queries. Used properly, this is totally fine. However, this can take down a website if used on the frontend.

For this reason, front facing endpoints should written by using the [Rewrite Rules API](http://codex.wordpress.org/Rewrite_API) and hooking early into the WordPress request process. Here is a simple example of how to structure your endpoints:

```php
<?php
function prefix_add_api_endpoints() {
	add_rewrite_tag( '%api_item_id%', '([0-9]+)' );
	add_rewrite_rule( 'api/items/([0-9]+)/?', 'index.php?api_item_id=$matches[1]', 'top' );
}
add_action( 'init', 'prefix_add_api_endpoints' );

function prefix_do_api() {
	global $wp_query;

	$item_id = $wp_query->get( 'api_item_id' );

	if ( ! empty( $item_id ) ) {
		$response = array();

		// Do stuff with $item_id

		wp_send_json( $response );
	}
}
add_action( 'template_redirect', 'prefix_do_api' );
?>
```

##### Cache Remote Requests

Requests made to third parties, whether synchronous or asynchronous, should be cached. Not doing so will result in your site's load time depend on an unreliable third party! Here is a quick code example:

```php
<?php
function prefix_get_posts_from_other_blog() {
    if ( false === ( $posts = wp_cache_get( 'prefix_other_blog_posts' ) ) {

        $request = wp_remote_get( ... );
        $posts = wp_remote_retrieve_body( $request );

        wp_cache_set( 'prefix_other_blog_posts, $posts, '', HOUR_IN_SECONDS );
    }

    return $posts
}
?>
```

```prefix_get_posts_form_other_blog()``` can be called to get posts from a third party and will handle caching internally.

#### Appropriately Storing Data

Utilizing built-in WordPress API's we can store data in a number of ways. We can store data using options, post meta, post types, object cache, and taxonomy terms. There are a number of performance considerations for each WordPress storage vehicle:

* [Options](http://codex.wordpress.org/Options_API) - The options API is a simple key-value storage system backed by a MySQL table. This API is mean't to store things like settings and not variable amounts of data.
* [Post Meta or Custom Fields](http://codex.wordpress.org/Custom_Fields) - Post meta is an API meant for storing information specific to a post. For example, if we had a custom post type, "Product", "serial number" would be information appropriate for post meta. Because of this, it usually doesn't make sense to search for groups of posts based on post meta
* [Taxonomies and Terms](http://codex.wordpress.org/Taxonomies) - Taxonomies are essentially groupings. If we have a "classification" that spans multiple posts, it is a good fit for a taxonomy term. For example, if we had a custom post type, "Product", "manufacturer" would be a good term since multiple products could have the same manufacturer. Taxonomy terms can be efficiently searched across as opposed to post meta.
* [Custom Post Types](http://codex.wordpress.org/Post_Types) - WordPress has the notion of "post types". "Post" is a post type which can be confusing. We can register custom post types to store all sorts of interesting pieces of data. If we have a variable amount of data to store such as a product, a custom post type might be a good fit.
* [Object Cache](http://codex.wordpress.org/Class_Reference/WP_Object_Cache) - See caching section.

#### Database Writes

Writing information to the database is at the core of any website we build. Here are some tips:

* Generally, do not write to the database on frontend pages as doing so can result in major performance issues and race conditions.

* When multiple threads (or page requests) read or write to a shared location in memory and the order of those read or writes is unknown, you have what is known as a [race condition](http://en.wikipedia.org/wiki/Race_condition).

* Store information in the correct place. See "Appropriately Storing Data" section.

* Certain options are "autoloaded" or put into the object cache on each page load. When [creating or updating options](http://codex.wordpress.org/Options_API), you can pass an ```$autoload``` argument to ```add_option()```. If your option is not going to get used often, it probably shouldn't be autoloaded. Unfortunately, ```update_option()``` automatically sets ```autoload``` to true so you have to use a combination of ```delete_option()``` and ```add_option()``` to accomplish this.

<h3 id="php-design-patterns">Design Patterns</h3>

Using a common set of design patterns while working with PHP code is the easiest way to ensure the maintainability of a project. This section addresses standard practices that set a low barrier for entry to new developers on the project.

#### Namespacing

All functional code should be properly namespaced. We do this to logically organize our code and to prevent collisions in the global namespace. Generally, this means using a PHP `namespace` identifier at the top of included files:

```php
<?php
namespace tenup\Utilities\API;

function do_something() {
  // ...
}
```

If the code is for general release to the WordPress.org theme or plugin repositories, we must match the minimum PHP compatibility of WordPress itself. Unfortunately, PHP namespaces are not supported in version < 5.3, so instead we will structure a class wrapping static functions to serve as a _pseudo_ namespace:

```php
<?php class Prefix_Utilities_API {
  public static function do_something() {
    // ...
  }
}
```

The similar structure of the namespace and the static class will allow for simple onboarding to either style of project (and a quick upgrade to PHP namespaces if/when WordPress raises its minimum version requirements).

Anything declared in the global namespace, including a namespace itself, should be written in such a way to ensure uniqueness. A namespace like ```tenup``` is (most likely) unique; ```theme``` is not. A simple way to ensure uniqueness is to prefix our declaration with unique prefix. Above we prefixed our class with ```Prefix_``` to demonstrate this concept.

#### Object Design

Firstly, if a function is not specific to an object, it should be included in a functional <a href="#namespacing">namespace</a> as referenced above.

Objects should be well-defined, atomic, and fully documented in the leading docblock for the file. Every function within the object must relate to the object itself.

```php
<?php
/**
 * Video
 *
 * This is a video object that wraps both traditional WordPress posts
 * and various YouTube meta information APIs hidden beneath them.
 *
 * @package    ClientTheme
 * @subpackage Content
 */
class Prefix_Video {

  /**
   * WordPress post object used for data storage.
   *
   * @var WP_Post
   */
  protected $_post;

  /**
   * Default video constructor.
   *
   * @uses get_post
   *
   * @throws Exception Throws an exception if the data passed is not a post or post ID.
   *
   * @var int|WP_Post $post
   */
  public function __construct( $post = null ) {
    if ( null === $post ) {
      throw new Exception( 'Invalid post supplied' );
    }

    $this->_post = get_post( $post );
  }
}
```

#### Visibility

In terms of OOP, public properties and methods should obviously be `public`. Anything intended to be private should actually be specified as `protected`. There should be no `private` fields or properties without well-documented and agreed upon rationale.

#### Structure and Patterns

Singletons are not advised - there is little justification for this pattern in practice and they cause more maintainability problems than they fix.

Class inheritance should be used where possible to produce [DRY](http://en.wikipedia.org/wiki/Don't_repeat_yourself) code and share previously developed components throughout the application.

Global variables should be avoided. If objects need to be passed throughout the theme/plugin, those object should either be passed as parameters or referenced through an object factory.

Hidden dependencies (API functions, super-globals, etc) should be documented in the docblock of every function/method.

<h3 id="php-security">Security</h3>

Security in the context of web development is a huge topic. This section only addresses what we can do at the server-side code level.

#### Input Validation and Sanitization

To validate is to ensure the data you've requested of the user matches what they've submitted. Sanitization is a broader approach ensuring data conforms to certain standards such as an integer or HTML-less text. The difference between validating and sanitizing data can be subtle at times and context dependant. Validation is always preferred to sanitization. Any non-static data that is stored in the database must be validated or sanitized. Not doing so can result in creating potential security vulnerabilities.

WordPress has a number of [validation and sanitization functions built-in](http://codex.wordpress.org/Validating_Sanitizing_and_Escaping_User_Data#Validating:_Checking_User_Input). Sometimes it can be confusing as to which is the most appropriate for a given situation. Sometimes it's even appropriate for us to write our own sanitization and validation methods.

Let's validate an integer we are storing in post meta:

```php
<?php
if ( ! empty( $_POST['user_id'] ) ) {
    update_post_meta( $post_id, 'key', absint( $_POST['user_id'] ) );
}
?>
```

```$_POST['user_id']``` is validated using ```absint()``` which ensures an integer >= 0. Without validation (or sanitization) ```$_POST['user_id']``` could be used maliciously to inject harmful code/data into the database.

Here is an example where we sanitize a text field to be stored in the database:

```php
<?php
if ( ! empty( $_POST['special_heading'] ) ) {
    update_option( 'option_key', sanitize_text_field( $_POST['special_heading'] ) );
}
?>
```

Since ```update_option()``` is storing in the database we must sanitize (or validate). Here we use the ```sanitize_text_field()``` function which is appropriate for general text fields.

##### Raw SQL Preparation and Sanitization

There are times when we need to deal directly with SQL. WordPress provides us with ```$wpdb``` (see [codex](http://codex.wordpress.org/Class_Reference/wpdb)). We must take special care to ensure our queries are properly prepared and sanitized:

```php
<?php
$wpdb->get_results( $wpdb->prepare( "SELECT id, name FROM $wpdb->posts WHERE ID='%d'", absint( $post_id ) ) );
?>
```

```$wpdb->prepare()``` behaves like ```sprintf()``` and essentially calls ```mysqli_real_escape_string()``` on each argument. ```mysqli_real_escape_string()``` escapes characters like ```'``` and ```"``` which prevents many SQL injection attacks. By using ```%d``` in ```sprintf()``` we are ensuring our argument is forced to be an integer. You might be wondering why we use ```absint()``` since it seems redundant. It's better to over sanitize then to miss something accidentally. Here is another example:

```php
<?php
$wpdb->insert( $wpdb->posts, array( 'post_excerpt' => wp_kses_post( $post_content ), array( '%s' ) );
?>
```

```$wpdb->insert()``` creates a new row in the database. We are passing ```$post_content``` into the ```post_content``` column. The third argument lets us specify a format for our values ```sprintf()``` style. Forcing our value to be a string using ```%s``` prevents many SQL injections attacks. However, we still need to call ```wp_kses_post()``` on ```$post_excerpt``` as someone could inject harmful JavaScript.

#### Escape or Validate Output

To escape is to ensure data conforms to specific standards before being passed off. Validation, again, ensures that data matches what is to be expected in a much stricter way. Any non-static data outputted to the browser must be escaped or validated. WordPress has a number of core functions we can leverage for escaping. At 10up, we follow the philosophy of *late escaping*. This means we escape things just before output in order to reduce missed escaping and improve code readability. Here are some simple examples:

```php
<div>
    <?php echo esc_html( get_post_meta( $post_id, 'key', true ) ); ?>
</div>
```

```esc_html()``` ensures output does not contain any html thus preventing JavaScript injection and layout breaks. Here is another example:

```php
<a href="mailto:<?php echo sanitize_email( get_post_meta( $post_id, 'key', true ) ); ?>">Email me</a>
```

```sanitize_email()``` ensures output is a valid email address. This is an example of validating our data. We could have used a broader escaping function like ```esc_attr()``` but instead we used ```sanitize_email()``` to validate. Here is another example:

```php
<script>
if ( document.cookie.indexOf( 'cookie_key' ) >= 0 ) {
    document.getElementById( 'test' ).getAttribute( 'href' ) = '<?php echo esc_js( get_post_meta( $post_id, 'key', true ) ); ?>';
}
</script>
```

```esc_js()``` ensures that whatever is returned is ok to be printed within a JavaScript string.

Sometimes we need to escape data that is meant to serve as an attribute. We can use ```esc_attr()``` to ensure output only contains characters appropriate for an attribute:

```php
<div class="<?php echo esc_attr( get_post_meta( $post_id, 'key', true ) ); ?>"></div>
```

If we need to escape such that HTML is permitted (but not harmful JavaScript), we usually have to use the ```wp_kses_*``` functions:

```php
<div>
    <?php echo wp_kses_post( get_post_meta( $post_id, 'meta_key', true ) ); ?>
</div>
```

```wp_kses_*``` functions should be used sparingly as they have bad performance due to a large number of regular expression matching attempts. If you find yourself using ```wp_kses_*```, it's worth evaluating what you are doing as whole. Are you providing a meta box for users to enter arbitrary HTML? Perhaps, you can add the HTML programmatically and provide the user with a few options to customize. If you do have to use wp_kses_*, output should be cached for as long as possible.

We even need to escape translated text. Generally, instead of use ```__()```, we should use ```esc_html__()```. Instead of using ```_e()```, we should use ```esc_html_e()```:

```php
<div>
    <?php esc_html_e( 'An example localized string.', 'my-domain' ) ?>
</div>
```

There are many escaping situations not covered in this section. Everyone should explore the [WordPress codex article](http://codex.wordpress.org/Validating_Sanitizing_and_Escaping_User_Data#Escaping:_Securing_Output) on escaping output to learn more.

#### Nonces

[WordPress Nonces](http://codex.wordpress.org/WordPress_Nonces) or numbers used only once is a tool used to prevent [CSRF](http://en.wikipedia.org/wiki/Cross-site_request_forgery) or cross-site request forgery. The purpose of a nonce is to make each request unique so an action cannot be replayed.

For example, to trash post 1 I might visit this URL: ```http://example.com/wp-admin/post.php?post=1&action=trash```. An attacker could trick me into visiting a URL like this ```http://example.com/wp-admin/post.php?post=2&action=trash``` since I am authenticated and authorized. For this reason, the trash action requires a valid nonce. After visiting ```http://example.com/wp-admin/post.php?post=1&action=trash&_wpnonce=b192fc4204```, the same nonce will not be valid in ```http://example.com/wp-admin/post.php?post=2&action=trash&_wpnonce=b192fc4204```.

Update and delete actions (like trashing a post) should require a valid nonce. Here is some example code:

```php
<form method="post" action="">
    <?php wp_create_nonce( 'my_action_name' ); ?>
    ...
</form>
```

When we process the form request, we check the nonce:

```php
<?php
if ( ! empty( $_POST['_wpnonce'] ) && wp_verify_nonce( $_POST['_wpnonce'], 'my_action_name' ) ) {
    // Nonce is valid!
}
?>
```

<h3 id="php-code-style">Code Style</h3>

We follow the [WordPress coding standards](http://make.wordpress.org/core/handbook/coding-standards/php/).

<h3 id="php-unit-testing">Unit and Integration Testing</h3>

Unit testing is the automated testing of units of source code against assumptions. The goal of unit testing is to write test cases with assumptions that test if a unit of code is truly working as intended. If an assumption fails, a potential issue is exposed, and code needs to be revised.

By definition unit tests do not have dependencies on outside systems; in other words only your code (a single unit of code) is being tested. Integration testing works similarly to unit tests but assumptions are tested against systems of code, moving parts, or an entire application. The phrases unit testing and integration testing are often misused to reference one another especially in the context of WordPress

At 10up, we generally employ unit and/or integration tests only when building applications that are meant to be distributed. Building tests for client themes does usually not offer a huge amount of value (there are of course exceptions to this). When we do write tests, we use PHPUnit which is a WordPress standard.

Read more at the [PHPUnit homepage](https://phpunit.de/) and [automated testing for WordPress](http://make.wordpress.org/core/handbook/automated-testing/)

<h3 id="php-libraries">Libraries and Frameworks</h3>

Generally, we do not use PHP frameworks or libraries that do not live within WordPress for general theme and plugin development. WordPress API's provide us with 99% of the functionality we need from database management to sending emails. There are frameworks and libraries we use for themes and plugins that are being distributed or open-sourced to the public such as PHPUnit.
