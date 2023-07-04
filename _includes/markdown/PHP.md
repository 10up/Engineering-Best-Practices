<h2 id="performance" class="anchor-heading">Performance {% include Util/link_anchor anchor="performance" %}</h2>

Writing performant code is absolutely critical, especially at the enterprise level. There are a number of strategies and best practices we must employ to ensure our code is optimized for high-traffic situations.

### Efficient Database Queries

When querying the database in WordPress, you should generally use a [```WP_Query```](https://developer.wordpress.org/reference/classes/wp_query/) object. ```WP_Query``` objects take a number of useful arguments and do things behind-the-scenes that other database access methods such as [```get_posts()```](https://developer.wordpress.org/reference/functions/get_posts/) do not.

Here are a few key points:

* Only run the queries that you need.

    A new ```WP_Query``` object runs five queries by default, including calculating pagination and priming the term and meta caches. Each of the following arguments will remove a query:

    * ```'no_found_rows' => true```: useful when pagination is not needed.
    * ```'update_post_meta_cache' => false```: useful when post meta will not be utilized.
    * ```'update_post_term_cache' => false```: useful when taxonomy terms will not be utilized.
    * ```'fields' => 'ids'```: useful when only the post IDs are needed (less typical).

* Do not use ```posts_per_page => -1```.

    This is a performance hazard. What if we have 100,000 posts? This could crash the site. If you are writing a widget, for example, and just want to grab all of a custom post type, determine a reasonable upper limit for your situation.

  ```php
  <?php
  // Query for 500 posts.
  new WP_Query( array(
    'posts_per_page' => 500,
  ));
  ?>
  ```

* Do not use ```$wpdb``` or ```get_posts()``` unless you have good reason.

    ```get_posts()``` actually calls ```WP_Query```, but calling ```get_posts()``` directly bypasses a number of filters by default. Not sure whether you need these things or not? You probably don't.

* If you don't plan to paginate query results, always pass ```no_found_rows => true``` to ```WP_Query```.

    This will tell WordPress not to run ```SQL_CALC_FOUND_ROWS``` on the SQL query, drastically speeding up your query. ```SQL_CALC_FOUND_ROWS``` calculates the total number of rows in your query which is required to know the total amount of "pages" for pagination.

  ```php
  <?php
  // Skip SQL_CALC_FOUND_ROWS for performance (no pagination).
  new WP_Query( array(
    'no_found_rows' => true,
  ));
  ?>
  ```

* Avoid using ```post__not_in```.

    In most cases it's quicker to filter out the posts you don't need in PHP instead of within the query. This also means it can take advantage of better caching. This won't work correctly (without additional tweaks) for pagination.

    Use :

  ```php
  <?php
  $foo_query = new WP_Query( array(
      'post_type' => 'post',
      'posts_per_page' => 30 + count( $posts_to_exclude )
  ) );

  if ( $foo_query->have_posts() ) :
      while ( $foo_query->have_posts() ) :
          $foo_query->the_post();
          if ( in_array( get_the_ID(), $posts_to_exclude ) ) {
              continue;
          }
          the_title();
      endwhile;
  endif;
  ?>
  ```

    Instead of:

  ```php
  <?php
  $foo_query = new WP_Query( array(
      'post_type' => 'post',
      'posts_per_page' => 30,
      'post__not_in' => $posts_to_exclude
  ) );
  ?>
  ```

    See [WordPress VIP](https://vip.wordpress.com/documentation/performance-improvements-by-removing-usage-of-post__not_in/).

* A [taxonomy](https://wordpress.org/support/article/taxonomies/) is a tool that lets us group or classify posts.

    [Post meta](https://wordpress.org/support/article/custom-fields/) lets us store unique information about specific posts. As such the way post meta is stored does not facilitate efficient post lookups. Generally, looking up posts by post meta should be avoided (sometimes it can't). If you have to use one, make sure that it's not the main query and that it's cached.

* Passing ```cache_results => false``` to ```WP_Query``` is usually not a good idea.

    If ```cache_results => true``` (which is true by default if you have caching enabled and an object cache setup), ```WP_Query``` will cache the posts found among other things. It makes sense to use ```cache_results => false``` in rare situations (possibly WP-CLI commands).

* Multi-dimensional queries should be avoided.

    Examples of multi-dimensional queries include:

      * Querying for posts based on terms across multiple taxonomies
      * Querying multiple post meta keys

    Each extra dimension of a query joins an extra database table. Instead, query by the minimum number of dimensions possible and use PHP to filter out results you don't need.

    Here is an example of a 2-dimensional query:

  ```php
  <?php
  // Query for posts with both a particular category and tag.
  new WP_Query( array(
    'category_name' => 'cat-slug',
    'tag' => 'tag-slug',
  ));
  ?>
  ```

#### WP\_Query vs. get\_posts() vs. query\_posts()
As outlined above, `get_posts()` and `WP_Query`, apart from some slight nuances, are quite similar. Both have the same performance cost (minus the implication of skipping filters): the query performed.

[`query_posts()`](https://developer.wordpress.org/reference/functions/query_posts/), on the other hand, behaves quite differently than the other two and should almost never be used. Specifically:

* It creates a new `WP_Query` object with the parameters you specify.
* It replaces the existing main query loop with a new instance of `WP_Query`.

As noted in the [WordPress Docs (along with a useful query flow chart)](https://developer.wordpress.org/reference/functions/query_posts/#more-information), `query_posts()` isn't meant to be used by plugins or themes. Due to replacing and possibly re-running the main query, `query_posts()` is not performant and certainly not an acceptable way of changing the main query.

#### Build arrays that encourage lookup by key instead of search by value

[`in_array()`](https://secure.php.net/manual/en/function.in-array.php) is not an efficient way to find if a given value is present in an array.
The worst case scenario is that the whole array needs to be traversed, thus making it a function with [O(n)](https://en.wikipedia.org/wiki/Big_O_notation#Orders_of_common_functions) complexity. VIP review reports `in_array()` use as an error, as it's known not to scale.

The best way to check if a value is present in an array is by building arrays that encourage lookup by key and use [`isset()`](https://secure.php.net/manual/en/function.isset.php).
`isset()` uses an [O(1)](https://en.wikipedia.org/wiki/Big_O_notation#Orders_of_common_functions) hash search on the key and will scale.

Here is an example of an array that encourages lookup by key by using the intended values as keys of an associative array

```php
<?php
$array = array(
 'foo' => true,
 'bar' => true,
);
if ( isset( $array['bar'] ) ) {
  // value is present in the array
};
```

In case you don't have control over the array creation process and are forced to use `in_array()`, to improve the performance slightly, you should always set the third parameter to `true` to force use of strict comparison.


### Caching

Caching is simply the act of storing computed data somewhere for later use, and is an incredibly important concept in WordPress. There are different ways to employ caching, and often multiple methods will be used.

#### The "Object Cache"

Object caching is the act of caching data or objects for later use. In the context of WordPress, objects are cached in memory so they can be retrieved quickly.

In WordPress, the object cache functionality provided by [```WP_Object_Cache```](https://developer.wordpress.org/reference/classes/wp_object_cache/), and the [Transients API](https://developer.wordpress.org/apis/handbook/transients/) are great solutions for improving performance on long-running queries, complex functions, or similar.

On a regular WordPress install, the difference between transients and the object cache is that transients are persistent and would write to the options table, while the object cache only persists for the particular page load.

It is possible to create a transient that will never expire by omitting the third parameter, this should be avoided as any non-expiring transients are autoloaded on every page and you may actually decrease performance by doing so.

On environments with a persistent caching mechanism (i.e. [Memcache](https://memcached.org/), [Redis](https://redis.io/), or similar) enabled, the transient functions become wrappers for the normal ```WP_Object_Cache``` functions. The objects are identically stored in the object cache and will be available across page loads.

High-traffic environments *not* using a persistent caching mechanism should be wary of using transients and filling the wp_options table with an excessive amount of data. See the "[Appropriate Data Storage](#appropriate-data-storage)" section for details.

Note: as the objects are stored in memory, you need to consider that these objects can be cleared at any time and that your code must be constructed in a way that it would not rely on the objects being in place.

This means you always need to ensure you check for the existence of a cached object and be ready to generate it in case it's not available. Here is an example:

```php
<?php
/**
 * Retrieve top 10 most-commented posts and cache the results.
 *
 * @return array|WP_Error Array of WP_Post objects with the highest comment counts,
 *                        WP_Error object otherwise.
 */
function prefix_get_top_commented_posts() {
    // Check for the top_commented_posts key in the 'top_posts' group.
    $top_commented_posts = wp_cache_get( 'prefix_top_commented_posts', 'top_posts' );

    // If nothing is found, build the object.
    if ( false === $top_commented_posts ) {
        // Grab the top 10 most commented posts.
        $top_commented_posts = new WP_Query( 'orderby=comment_count&posts_per_page=10' );

        if ( ! is_wp_error( $top_commented_posts ) && $top_commented_posts->have_posts() ) {
            // Cache the whole WP_Query object in the cache and store it for 5 minutes (300 secs).
            wp_cache_set( 'prefix_top_commented_posts', $top_commented_posts->posts, 'top_posts', 5 * MINUTE_IN_SECONDS );
        }
    }
    return $top_commented_posts;
}
?>
```

In the above example, the cache is checked for an object with the 10 most commented posts and would generate the list in case the object is not in the cache yet. Generally, calls to ```WP_Query``` other than the main query should be cached.

As the content is cached for 300 seconds, the query execution is limited to one time every 5 minutes, which is nice.

However, the cache rebuild in this example would always be triggered by a visitor who would hit a stale cache, which will increase the page load time for the visitors and under high-traffic conditions. This can cause race conditions when a lot of people hit a stale cache for a complex query at the same time. In the worst case, this could cause queries at the database server to pile up causing replication, lag, or worse.

That said, a relatively easy solution for this problem is to make sure that your users would ideally always hit a primed cache. To accomplish this, you need to think about the conditions that need to be met to make the cached value invalid. In our case this would be the change of a comment.

The easiest hook we could identify that would be triggered for any of this actions would be [```wp_update_comment_count```](https://developer.wordpress.org/reference/hooks/wp_update_comment_count/) set as ```do_action( 'wp_update_comment_count', $post_id, $new, $old )```.

With this in mind, the function could be changed so that the cache would always be primed when this action is triggered.

Here is how it's done:

```php
<?php
/**
 * Prime the cache for the top 10 most-commented posts.
 *
 * @param int $post_id Post ID.
 * @param int $new     The new comment count.
 * @param int $old     The old comment count.
 */
function prefix_refresh_top_commented_posts( $post_id, $new, $old ) {
    // Force the cache refresh for top-commented posts.
    prefix_get_top_commented_posts( $force_refresh = true );
}
add_action( 'wp_update_comment_count', 'prefix_refresh_top_commented_posts', 10, 3 );

/**
 * Retrieve top 10 most-commented posts and cache the results.
 *
 * @param bool $force_refresh Optional. Whether to force the cache to be refreshed. Default false.
 * @return array|WP_Error Array of WP_Post objects with the highest comment counts, WP_Error object otherwise.
 */
function prefix_get_top_commented_posts( $force_refresh = false ) {
    // Check for the top_commented_posts key in the 'top_posts' group.
    $top_commented_posts = wp_cache_get( 'prefix_top_commented_posts', 'top_posts' );

    // If nothing is found, build the object.
    if ( true === $force_refresh || false === $top_commented_posts ) {
        // Grab the top 10 most commented posts.
        $top_commented_posts = new WP_Query( 'orderby=comment_count&posts_per_page=10' );

        if ( ! is_wp_error( $top_commented_posts ) && $top_commented_posts->have_posts() ) {
            // In this case we don't need a timed cache expiration.
            wp_cache_set( 'prefix_top_commented_posts', $top_commented_posts->posts, 'top_posts' );
        }
    }
    return $top_commented_posts;
}
?>
```

With this implementation, you can keep the cache object forever and don't need to add an expiration for the object as you would create a new cache entry whenever it is required. Just keep in mind that some external caches (like Memcache) can invalidate cache objects without any input from WordPress.

For that reason, it's best to make the code that repopulates the cache available for many situations.

In some cases, it might be necessary to create multiple objects depending on the parameters a function is called with. In these cases, it's usually a good idea to create a cache key which includes a representation of the variable parameters. A simple solution for this would be appending an md5 hash of the serialized parameters to the key name.

#### Page Caching

Page caching in the context of web development refers to storing a requested location's entire output to serve in the event of subsequent requests to the same location.

[Batcache](https://wordpress.org/plugins/batcache) is a WordPress plugin that uses the object cache (often Memcache in the context of WordPress) to store and serve rendered pages. It can also optionally cache redirects. It's not as fast as some other caching plugins, but it can be used where file-based caching is not practical or desired.

Batcache is aimed at preventing a flood of traffic from breaking your site. It does this by serving old (5 minute max age by default, but adjustable) pages to new users. This reduces the demand on the web server CPU and the database. It also means some people may see a page that is a few minutes old. However, this only applies to people who have not interacted with your website before. Once they have logged-in or left a comment, they will always get fresh pages.

Although this plugin has a lot of benefits, it also has a couple of code design requirements:

* As the rendered HTML of your pages might be cached, you cannot rely on server side logic related to ```$_SERVER```, ```$_COOKIE``` or other values that are unique to a particular user.
* You can however implement cookie or other user based logic on the front-end (e.g. with JavaScript)

Batcache does not cache logged in users (based on WordPress login cookies), so keep in mind the performance implications for subscription sites (like BuddyPress). Batcache also treats the query string as part of the URL which means the use of query strings for tracking campaigns (common with Google Analytics) can render page caching ineffective.  Also beware that while WordPress VIP uses batcache, there are specific rules and conditions on VIP that do not apply to the open source version of the plugin.

There are other popular page caching solutions such as the W3 Total Cache plugin, though we generally do not use them for a variety of reasons.

##### AJAX Endpoints

AJAX stands for Asynchronous JavaScript and XML. Often, we use JavaScript on the client-side to ping endpoints for things like infinite scroll.

WordPress [provides an API](https://developer.wordpress.org/plugins/javascript/ajax/) to register AJAX endpoints on ```wp-admin/admin-ajax.php```. However, WordPress does not cache queries within the administration panel for obvious reasons. Therefore, if you send requests to an admin-ajax.php endpoint, you are bootstrapping WordPress and running un-cached queries. Used properly, this is totally fine. However, this can take down a website if used on the frontend.

For this reason, front-facing endpoints should be written by using the [Rewrite Rules API](https://developer.wordpress.org/apis/handbook/rewrite/) and hooking early into the WordPress request process.

Here is a simple example of how to structure your endpoints:

```php
<?php
/**
 * Register a rewrite endpoint for the API.
 */
function prefix_add_api_endpoints() {
	add_rewrite_tag( '%api_item_id%', '([0-9]+)' );
	add_rewrite_rule( 'api/items/([0-9]+)/?', 'index.php?api_item_id=$matches[1]', 'top' );
}
add_action( 'init', 'prefix_add_api_endpoints' );

/**
 * Handle data (maybe) passed to the API endpoint.
 */
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

#### Cache Remote Requests

Requests made to third-parties, whether synchronous or asynchronous, should be cached. Not doing so will result in your site's load time depending on an unreliable third-party!

Here is a quick code example for caching a third-party request:

```php
<?php
/**
 * Retrieve posts from another blog and cache the response body.
 *
 * @return string Body of the response. Empty string if no body or incorrect parameter given.
 */
function prefix_get_posts_from_other_blog() {
    if ( false === ( $posts = wp_cache_get( 'prefix_other_blog_posts' ) ) ) {

        $request = wp_remote_get( ... );
        $posts = wp_remote_retrieve_body( $request );

        wp_cache_set( 'prefix_other_blog_posts', $posts, '', HOUR_IN_SECONDS );
    }
    return $posts;
}
?>
```

```prefix_get_posts_from_other_blog()``` can be called to get posts from a third-party and will handle caching internally.

### Appropriate Data Storage

Utilizing built-in WordPress APIs we can store data in a number of ways.

We can store data using options, post meta, post types, object cache, and taxonomy terms.

There are a number of performance considerations for each WordPress storage vehicle:

* [Options](https://developer.wordpress.org/apis/handbook/options/) - The options API is a simple key-value storage system backed by a MySQL table. This API is meant to store things like settings and not variable amounts of data.

  Site performance, especially on large websites, can be negatively affected by a large options table. It's recommended to regularly monitor and keep this table under 500 rows. The "autoload" field should only be set to 'yes' for values that need to be loaded into memory on each page load.

  Caching plugins can also be negatively affected by a large wp_options table. Popular caching plugins such as [Memcached](https://wordpress.org/plugins/memcached/) place a 1MB limit on individual values stored in cache. A large options table can easily exceed this limit, severely slowing each page load.

* [Post Meta or Custom Fields](https://wordpress.org/support/article/custom-fields/) - Post meta is an API meant for storing information specific to a post. For example, if we had a custom post type, "Product", "serial number" would be information appropriate for post meta. Because of this, it usually doesn't make sense to search for groups of posts based on post meta.
* [Taxonomies and Terms](https://wordpress.org/support/article/taxonomies/) - Taxonomies are essentially groupings. If we have a classification that spans multiple posts, it is a good fit for a taxonomy term. For example, if we had a custom post type, "Car", "Nissan" would be a good term since multiple cars are made by Nissan. Taxonomy terms can be efficiently searched across as opposed to post meta.
* [Custom Post Types](https://wordpress.org/support/article/post-types/) - WordPress has the notion of "post types". "Post" is a post type which can be confusing. We can register custom post types to store all sorts of interesting pieces of data. If we have a variable amount of data to store such as a product, a custom post type might be a good fit.
* [Object Cache](https://developer.wordpress.org/reference/classes/wp_object_cache/) - See the "[Caching](#caching)" section.

While it is possible to use WordPress' [Filesystem API](https://developer.wordpress.org/apis/handbook/filesystem/) to interact with a huge variety of storage endpoints, using the filesystem to store and deliver data outside of regular asset uploads should be avoided as this methods conflict with most modern / secure hosting solutions.

### Database Writes

Writing information to the database is at the core of any website you build. Here are some tips:

* Generally, do not write to the database on frontend pages as doing so can result in major performance issues and race conditions.

* When multiple threads (or page requests) read or write to a shared location in memory and the order of those read or writes is unknown, you have what is known as a [race condition](https://en.wikipedia.org/wiki/Race_condition).

* Store information in the correct place. See the "[Appropriate Data Storage](#appropriate-data-storage)" section.

* Certain options are "autoloaded" or put into the object cache on each page load. When [creating or updating options](https://developer.wordpress.org/apis/handbook/options/), you can pass an ```$autoload``` argument to [```add_option()```](https://developer.wordpress.org/reference/functions/add_option/). If your option is not going to get used often, it shouldn't be autoloaded. As of WordPress 4.2, [```update_option()```](https://developer.wordpress.org/reference/functions/update_option/) supports configuring autoloading directly by passing an optional ```$autoload``` argument. Using this third parameter is preferable to using a combination of [```delete_option()```](https://developer.wordpress.org/reference/functions/delete_option/) and ```add_option()``` to disable autoloading for existing options.

<h2 id="design-patterns" class="anchor-heading">Design Patterns {% include Util/link_anchor anchor="design-patterns" %} {% include Util/top %}</h2>

Using a common set of design patterns while working with PHP code is the easiest way to ensure the maintainability of a project. This section addresses standard practices that set a low barrier for entry to new developers on the project.

### Namespacing

We properly namespace all PHP code outside of theme templates. This means any PHP file that isn't part of the [WordPress Template Hierarchy](https://developer.wordpress.org/themes/basics/template-hierarchy/) should be organized within a namespace so its contents don't conflict with other, similarly-named classes and functions ("namespace collisions").

Generally, this means including a PHP ```namespace``` identifier at the top of included files:

```php
<?php
namespace TenUp\Buy_N_Large\Wall_E;

function do_something() {
  // ...
}
```

A namespace identifier consists of a _top-level_ namespace or "Vendor Name", which is usually ```TenUp``` for our projects. We follow the top-level name with a project name, usually a client's name. e.g. ```TenUp\Buy_N_Large;```

Additional levels of the namespace are defined at discretion of the project's lead engineers. Around the time of a project's kickoff, they agree on a strategy for namespacing the project's code. For example, the client's name may be followed with the name of a particular site or high-level project we're building (```TenUp\Buy_N_Large\Wall_E;```).

When Kanopi works on more than one project for a client and we build common plugins shared between sites, "Common" might be used in place of the project name to signal this code's relationship to the rest of the codebase.

The engineering leads document this strategy so it can be shared with engineers brought onto the project throughout its lifecycle.

[```use``` declarations](https://secure.php.net/manual/en/language.namespaces.importing.php) should be used for classes outside a file's namespace. By declaring the full namespace of a class we want to use *once* at the top of the file, we can refer to it by just its class name, making code easier to read. It also documents a file's dependencies for future developers.

```php
<?php
/**
 * Example of a 'use' declaration
 */
namespace TenUp\Buy_N_Large\Wall_E;
use TenUp\Buy_N_Large\Common\TwitterAPI;

function do_something() {
  // Hard to read
  $twitter_api = new TenUp\Buy_N_Large\Common\TwitterAPI();
  // Preferred
  $twitter_api = new TwitterAPI();
}
```

Anything declared in the global namespace, including a namespace itself, should be written in such a way as to ensure uniqueness. A namespace like ```TenUp``` is (most likely) unique; ```theme``` is not. A simple way to ensure uniqueness is to prefix a declaration with a unique prefix.

### Object Design

Firstly, if a function is not specific to an object, it should be included in a functional [namespace](#namespacing) as referenced above.

Objects should be well-defined, atomic, and fully documented in the leading docblock for the file. Every method and property within the object must themselves be fully documented, and relate to the object itself.

```php
<?php
/**
 * Video.
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
	 * @access protected
	 * @var WP_Post
	 */
	protected $_post;

	/**
	 * Default video constructor.
	 *
	 * @access public
	 *
	 * @see get_post()
	 * @throws Exception Throws an exception if the data passed is not a post or post ID.
	 *
	 * @param int|WP_Post $post Post ID or WP_Post object.
	 */
	public function __construct( $post = null ) {
		if ( null === $post ) {
			throw new Exception( 'Invalid post supplied' );
		}

		$this->_post = get_post( $post );
	}
}
```

### Visibility

In terms of [Object-Oriented Programming](https://en.wikipedia.org/wiki/Object-oriented_programming) (OOP), public properties and methods should obviously be `public`. Anything intended to be private should actually be specified as `protected`. There should be no `private` fields or properties without well-documented and agreed-upon rationale.

### Structure and Patterns

* Singletons are not advised. There is little justification for this pattern in practice and they cause more maintainability problems than they fix.
* Class inheritance should be used where possible to produce [DRY](https://en.wikipedia.org/wiki/Don't_repeat_yourself) code and share previously-developed components throughout the application.
* Global variables should be avoided. If objects need to be passed throughout the theme or plugin, those objects should either be passed as parameters or referenced through an object factory.
* Hidden dependencies (API functions, super-globals, etc) should be documented in the docblock of every function/method or property.
* Avoid registering hooks in the __construct method. Doing so tightly couples the hooks to the instantiation of the class and is less flexible than registering the hooks via a separate method. Unit testing becomes much more difficult as well.

### Decouple Plugin and Theme using add_theme_support

The implementation of a custom plugin should be decoupled from its use
in a Theme. Disabling the plugin should not result in any errors in the
Theme code. Similarly switching the Theme should not result in any
errors in the Plugin code.

The best way to implement this is with the use of [add_theme_support](https://developer.wordpress.org/reference/functions/add_theme_support/) and [current_theme_supports](https://developer.wordpress.org/reference/functions/current_theme_supports/).

Consider a plugin that adds a custom javascript file to the `page` post
type. The Theme should register support for this feature using
`add_theme_support`,

```php
<?php
add_theme_support( 'custom-js-feature' );
```

And the plugin should check that the current theme has indicated support
for this feature before adding the script to the page, using
[current_theme_supports](https://developer.wordpress.org/reference/functions/current_theme_supports/),

```php
<?php
if ( current_theme_supports( 'custom-js-feature' ) ) {
	// ok to add custom js
}
```

### Asset Versioning
It's always a good idea to keep assets versioned, to make cache busting a simpler process when deploying new code. Fortunately, [wp_register_script](https://developer.wordpress.org/reference/functions/wp_register_script/) and [wp_register_style](https://developer.wordpress.org/reference/functions/wp_register_style/) provide a built-in API that allows engineers to declare an asset version, which is then appended to the file name as a query string when the asset is loaded.

It is recommended that engineers use a constant to define their theme or plugin version, then reference that constant when using registering scripts or styles. For example:

```php
<?php
define( 'THEME_VERSION', '0.1.0' );

wp_register_script( 'custom-script', get_template_directory_uri() . '/js/asset.js', array(), THEME_VERSION );
```

Remember to increment the version in the defined constant prior to deployment.

<h2 id="security" class="anchor-heading">Security {% include Util/link_anchor anchor="security" %} {% include Util/top %}</h2>

Security in the context of web development is a huge topic. This section only addresses some of the things we can do at the server-side code level.

### Input Validation and Sanitization

To validate is to ensure the data you've requested of the user matches what they've submitted. Sanitization is a broader approach ensuring data conforms to certain standards such as an integer or HTML-less text. The difference between validating and sanitizing data can be subtle at times and context-dependent.

Validation is always preferred to sanitization. Any non-static data that is stored in the database must be validated or sanitized. Not doing so can result in creating potential security vulnerabilities.

WordPress has a number of [validation](https://developer.wordpress.org/plugins/security/data-validation/#core-wordpress-functions) and [sanitization](https://developer.wordpress.org/themes/theme-security/data-sanitization-escaping/#sanitization-securing-input) functions built-in.

Sometimes it can be confusing as to which is the most appropriate for a given situation. Other times, it's even appropriate to write our own sanitization and validation methods.

Here's an example of validating an integer stored in post meta:

```php
<?php
if ( ! empty( $_POST['user_id'] ) ) {
    if ( absint( $_POST['user_id'] ) === $_POST['user_id'] ) {
        update_post_meta( $post_id, 'key', absint( $_POST['user_id'] ) );
    }
}
?>
```

```$_POST['user_id']``` is validated using [```absint()```](https://developer.wordpress.org/reference/functions/absint/) which ensures an integer >= 0. Without validation (or sanitization), ```$_POST['user_id']``` could be used maliciously to inject harmful code or data into the database.

Here is an example of sanitizing a text field value that will be stored in the database:

```php
<?php
if ( ! empty( $_POST['special_heading'] ) ) {
    update_option( 'option_key', sanitize_text_field( $_POST['special_heading'] ) );
}
?>
```

Since ```update_option()``` is storing in the database, the value must be sanitized (or validated). The example uses the [```sanitize_text_field()```](https://developer.wordpress.org/reference/functions/sanitize_text_field/) function, which is appropriate for sanitizing general text fields.

#### Raw SQL Preparation and Sanitization

There are times when dealing directly with SQL can't be avoided. WordPress provides us with [```$wpdb```](https://developer.wordpress.org/reference/classes/wpdb/).

Special care must be taken to ensure queries are properly prepared and sanitized:

```php
<?php
global $wpdb;

$wpdb->get_results( $wpdb->prepare( "SELECT id, name FROM $wpdb->posts WHERE ID='%d'", absint( $post_id ) ) );
?>
```

```$wpdb->prepare()``` behaves like ```sprintf()``` and essentially calls ```mysqli_real_escape_string()``` on each argument. ```mysqli_real_escape_string()``` escapes characters like ```'``` and ```"``` which prevents many SQL injection attacks.

By using ```%d``` in ```sprintf()```, we are ensuring the argument is forced to be an integer. You might be wondering why ```absint()``` was used since it seems redundant. It's better to over sanitize than to miss something accidentally.

Here is another example:

```php
<?php
global $wpdb;

$wpdb->insert( $wpdb->posts, array( 'post_content' => wp_kses_post( $post_content ), array( '%s' ) ) );
?>
```

```$wpdb->insert()``` creates a new row in the database. ```$post_content``` is being passed into the ```post_content``` column. The third argument lets us specify a format for our values ```sprintf()``` style. Forcing the value to be a string using the ```%s``` specifier prevents many SQL injection attacks. However, ```wp_kses_post()``` still needs to be called on ```$post_content``` as someone could inject harmful JavaScript otherwise.

### Escape or Validate Output

To escape is to ensure data conforms to specific standards before being passed off. Validation, again, ensures that data matches what is to be expected in a much stricter way. Any non-static data outputted to the browser must be escaped or validated.

WordPress has a number of core functions that can be leveraged for escaping. At Kanopi, we follow the philosophy of *late escaping*. This means we escape things just before output in order to reduce missed escaping and improve code readability.

Here are some simple examples of *late-escaped* output:

```php
<div>
    <?php echo esc_html( get_post_meta( $post_id, 'key', true ) ); ?>
</div>
```

[```esc_html()```](https://developer.wordpress.org/reference/functions/esc_html/) ensures output does not contain any HTML thus preventing JavaScript injection and layout breaks.

Here is another example:

```php
<a href="mailto:<?php echo sanitize_email( get_post_meta( $post_id, 'key', true ) ); ?>">Email me</a>
```

[```sanitize_email()```](https://developer.wordpress.org/reference/functions/sanitize_email/) ensures output is a valid email address. This is an example of validating our data. A broader escaping function like [```esc_attr()```](https://developer.wordpress.org/reference/functions/esc_attr/) could have been used, but instead ```sanitize_email()``` was used to validate.

Here is another example:

```php
<input type="text" onfocus="if( this.value == '<?php echo esc_js( $fields['input_text'] ); ?>' ) { this.value = ''; }" name="name">
```

[```esc_js()```](https://developer.wordpress.org/reference/functions/esc_js/) ensures that whatever is returned is safe to be printed within a JavaScript string. This function is intended to be used for inline JS, inside a tag attribute (onfocus="...", for example).

We should not be writing JavaScript inside tag attributes anymore, this means that ```esc_js()``` should never be used. To escape strings for JS another function should be used.

Here is another example:

```php
<script>
if ( document.cookie.indexOf( 'cookie_key' ) >= 0 ) {
document.getElementById( 'test' ).getAttribute( 'href' ) = <?php echo wp_json_encode( get_post_meta( $post_id, 'key', true ) ); ?>;
}
</script>
```

[```wp_json_encode()```](https://developer.wordpress.org/reference/functions/wp_json_encode/) ensures that whatever is returned is safe to be printed in your JavaScript code. It returns a JSON encoded string.

Note that ```wp_json_encode()``` includes the string-delimiting quotes for you.

Sometimes you need to escape data that is meant to serve as an attribute. For that, you can use ```esc_attr()``` to ensure output only contains characters appropriate for an attribute:

```php
<div class="<?php echo esc_attr( get_post_meta( $post_id, 'key', true ) ); ?>"></div>
```

If you need to escape such that HTML is permitted (but not harmful JavaScript), the ```wp_kses_*``` functions can be used:

```php
<div>
    <?php echo wp_kses_post( get_post_meta( $post_id, 'meta_key', true ) ); ?>
</div>
```

```wp_kses_*``` functions should be used sparingly as they have bad performance due to a large number of regular expression matching attempts. If you find yourself using ```wp_kses_*```, it's worth evaluating what you are doing as a whole.

Are you providing a meta box for users to enter arbitrary HTML? Perhaps you can generate the HTML programmatically and provide the user with a few options to customize.

If you do have to use ```wp_kses_*``` on the frontend, output should be cached for as long as possible.

Translated text also often needs to be escaped on output.

Here's an example:

```php
<div>
    <?php esc_html_e( 'An example localized string.', 'my-domain' ) ?>
</div>
```

Instead of using the generic [```__()```](https://developer.wordpress.org/reference/functions/__/) function, something like [```esc_html__()```](https://developer.wordpress.org/reference/functions/esc_html__/) might be more appropriate. Instead of using the generic [```_e()```](https://developer.wordpress.org/reference/functions/_e/) function, [```esc_html_e()```](https://developer.wordpress.org/reference/functions/esc_html_e/) would instead be used.

There are many escaping situations not covered in this section. Everyone should explore the [WordPress Plugin Handbook section](https://developer.wordpress.org/plugins/security/securing-output/) on escaping output to learn more.

### Nonces

In programming, a nonce, or number used only once, is a tool used to prevent [CSRF](https://en.wikipedia.org/wiki/Cross-site_request_forgery) or cross-site request forgery.

The purpose of a nonce is to make each request unique so an action cannot be replayed.

WordPress' [implementation](https://developer.wordpress.org/plugins/security/nonces/) of nonces are not strictly numbers used once, though they serve an equal purpose.

The literal WordPress definition of nonces is "A cryptographic token tied to a specific action, user, and window of time.". This means that while the number is not a true nonce, the resulting number *is* specifically tied to the action, user, and window of time for which it was generated.

Let's say you want to trash a post with `ID` 1. To do that, you might visit this URL: ```https://example.com/wp-admin/post.php?post=1&action=trash```

Since you are authenticated and authorized, an attacker could trick you into visiting a URL like this: ```https://example.com/wp-admin/post.php?post=2&action=trash```

For this reason, the trash action requires a valid WordPress nonce.

After visiting ```https://example.com/wp-admin/post.php?post=1&action=trash&_wpnonce=b192fc4204```, the same nonce will not be valid in ```https://example.com/wp-admin/post.php?post=2&action=trash&_wpnonce=b192fc4204```.

Update and delete actions (like trashing a post) should require a valid nonce.

Here is some example code for creating a nonce:

```php
<form method="post" action="">
    <?php wp_nonce_field( 'my_action_name' ); ?>
    ...
</form>
```

When the form request is processed, the nonce must be verified:

```php
<?php
// Verify the nonce to continue.
if ( ! empty( $_POST['_wpnonce'] ) && wp_verify_nonce( $_POST['_wpnonce'], 'my_action_name' ) ) {
    // Nonce is valid!
}
?>
```

### Internationalization

All text strings in a project should be internationalized using core localization functions. Even if the project does not currently dictate a need for translatable strings, this practice ensures translation-readiness should a future need arise.

WordPress provides a myriad of [localization functionality](https://developer.wordpress.org/plugins/internationalization/). Engineers should familiarize themselves with features such as [pluralization](https://developer.wordpress.org/plugins/internationalization/how-to-internationalize-your-plugin/#plurals) and [disambiguation](https://developer.wordpress.org/plugins/internationalization/how-to-internationalize-your-plugin/#disambiguation-by-context) so translations are flexible and translators have the information they need to work accurately.

Samuel Wood (Otto) put together a guide to WordPress internationalization best practices, and engineers should take time to familiarize themselves with its guidance: [Internationalization: You’re probably doing it wrong](http://ottopress.com/2012/internationalization-youre-probably-doing-it-wrong/)

It's important to note that the strings passed to translation functions should always be literal strings, never variables or named constants, and code shouldn't use [string interpolation](https://en.wikipedia.org/wiki/String_interpolation#PHP) to inject values into either string. Most tools used to create translations rely on [GNU gettext](https://www.gnu.org/software/gettext/) scanning source code for translation functions. PHP code won't be interpreted, only scanned like it was a block of plain text and stored similarly. If WordPress's translation APIs can't find an exact match for a string inside the translation files, it won't be able to translate the string. Instead, use [printf formatting codes](https://en.wikipedia.org/wiki/Printf_format_string) inside the string to be translated and pass the translated version of that string to sprintf() to fill in the values.

For example:
```php
<?php
// This will confuse translation software
$string = __( "$number minutes left", 'plugin-domain' );
// So will this
define( 'MINUTES_LEFT', '%d minutes left' );
$string = __( MINUTES_LEFT, 'plugin-domain' );
// Correct way to do a simple translation
$string = sprintf( __( '%d minutes left', 'plugin-domain' ), $number );
// A more complex translation using _n() for plurals
$string = sprintf( _n( '%d minute left', '%d minutes left',  $number, 'plugin-domain' ), $number );
?>
```

Localizing a project differs from the core approach in two distinct ways:
* A unique text domain should be used with all localization functions
* Internationalized output should always be escaped

#### Text Domains

Each project should leverage a unique text domain for its strings. Text domains should be lowercase, alphanumeric, and use hyphens to separate multiple words: `tenup-project-name`.

Like the translated strings they accompany, text domains should never be stored in a variable or named constant when used with core localization functions, as this practice can often produce unexpected results. Translation tools won't interpret PHP code, only scan it like it was plain text. They won't be able to assign the text domain correctly if it's not there in plain text.

```php
<?php
// Always this
$string = __( 'Hello World', 'plugin-domain' );
// Never this
$string = __( 'Hello World', $plugin_domain );
// Or this
define( 'PLUGIN_DOMAIN', 'plugin-domain' );
$string = __( 'Hello World', PLUGIN_DOMAIN );
?>
```

If the code is for release as a plugin or theme in the WordPress.org repositories, the text domain *must* match the directory slug for the project in order to ensure compatibility with the WordPress language pack delivery system. The text domain should be defined in the "Text Domain" header in the plugin or stylesheet headers, respectively, so the community can use [GlotPress](https://wordpress.org/plugins/glotpress/) to provide new translations.

#### Escaping Strings

Most of WordPress's translation functions don't escape output by default. So, it's important to escape the translated strings like any other content.

To make this easier, the WordPress API includes functions that translate and escape in a single step. Engineers are encouraged to use these functions to simplify their code:

**For use in HTML**
1. [esc_html__](https://developer.wordpress.org/reference/functions/esc_html__/): Returns a translated and escaped string
1. [esc_html_e](https://developer.wordpress.org/reference/functions/esc_html_e/): Echoes a translated and escaped string
1. [esc_html_x](https://developer.wordpress.org/reference/functions/esc_html_x/): Returns a translated and escaped string, *passing a context* to the translation function

**For use in attributes**
1. [esc_attr__](https://developer.wordpress.org/reference/functions/esc_attr__/): Returns a translated and escaped string
1. [esc_attr_e](https://developer.wordpress.org/reference/functions/esc_attr_e/): Echoes a translated and escaped string
1. [esc_attr_x](https://developer.wordpress.org/reference/functions/esc_attr_x/): Returns a translated and escaped string, *passing a context* to the translation function

<h2 id="code-style" class="anchor-heading">Code Style & Documentation {% include Util/link_anchor anchor="code-style" %} {% include Util/top %}</h2>

We follow the official WordPress [coding](https://make.wordpress.org/core/handbook/best-practices/coding-standards/php/) and [documentation](https://make.wordpress.org/core/handbook/best-practices/inline-documentation-standards/php/) standards. The [WordPress Coding Standards for PHP_CodeSniffer](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards) will find many common violations and flag risky code for manual review.

That said, at Kanopi we highly value verbose commenting/documentation throughout any/all code, with an emphasis on docblock long descriptions which state 'why' the code is there and 'what' exactly the code does in human-readable prose. As a general rule of thumb; a manager should be able to grok your code by simply reading the docblock and inline comments.

Example:

```php
<?php
/**
 * Hook into WordPress to mark specific post meta keys as protected
 *
 * Post meta can be either public or protected. Any post meta which holds
 * **internal or read only** data should be protected via a prefixed underscore on
 * the meta key (e.g. _my_post_meta) or by indicating it's protected via the
 * is_protected_meta filter.
 *
 * Note, a meta field that is intended to be a viewable component of the post
 * (Examples: event date, or employee title) should **not** be protected.
 */
add_filter( 'is_protected_meta', 'protect_post_meta', 10, 2 );

/**
 * Protect non-public meta keys
 *
 * Flag some post meta keys as private so they're not exposed to the public
 * via the Custom Fields meta box or the JSON REST API.
 *
 * @internal                          Called via is_protected_meta filter.
 * @param    bool   $protected        Whether the key is protected. Default is false.
 * @param    string $current_meta_key The meta key being referenced.
 * @return   bool   $protected        The (possibly) modified $protected variable
 */
function protect_post_meta( $protected, $current_meta_key ) {

    // Assemble an array of post meta keys to be protected
    $meta_keys_to_be_protected = array(
        'my_meta_key',
        'my_other_meta_key',
        'and_another_meta_key',
    );

    // Set the protected var to true when the current meta key matches
    // one of the meta keys in our array of keys to be protected
    if ( in_array( $current_meta_key, $meta_keys_to_be_protected ) ) {
        $protected = true;
    }

    // Return the (possibly modified) $protected variable.
    return $protected;
}
?>
```

<h2 id="unit-testing" class="anchor-heading">Unit and Integration Testing {% include Util/link_anchor anchor="unit-testing" %} {% include Util/top %}</h2>

Unit testing is the automated testing of units of source code against certain assertions. The goal of unit testing is to write test cases with assertions that test if a unit of code is truly working as intended. If an assertion fails, a potential issue is exposed, and code needs to be revised.

By definition, unit tests do not have dependencies on outside systems; in other words, only your code (a single unit of code) is being tested. Integration testing works similarly to unit tests but assumptions are tested against systems of code, moving parts, or an entire application. The phrases unit testing and integration testing are often misused to reference one another especially in the context of WordPress.

At Kanopi, we generally employ unit and integration tests only when building applications that are meant to be distributed. Building tests for client themes doesn't usually offer a huge amount of value (there are of course exceptions to this). When we do write tests, we use PHPUnit which is the WordPress standard library.

Read more at the [PHPUnit homepage](https://phpunit.de/) and [automated testing for WordPress](https://make.wordpress.org/core/handbook/testing/automated-testing/).

<h2 id="libraries" class="anchor-heading">Libraries and Frameworks {% include Util/link_anchor anchor="libraries" %} {% include Util/top %}</h2>

Generally, we do not use PHP frameworks or libraries that do not live within WordPress for general theme and plugin development. WordPress APIs provide us with 99 percent of the functionality we need from database management to sending emails. There are frameworks and libraries we use for themes and plugins that are being distributed or open-sourced to the public such as PHPUnit.

## Avoid *Heredoc* and *Nowdoc*

PHP's *doc syntaxes* construct large strings of HTML within code, without the hassle of concatenating a bunch of one-liners. They tend to be easier to read, and are easier for inexperienced front-end developers to edit without accidentally breaking PHP code.

```php
$y = <<<JOKE
I told my doctor
"it hurts when I move my arm like this".
He said, "<em>then stop moving it like that!</em>"
JOKE;
```

However, heredoc/nowdoc make it impossible to practice *late escaping*:

```php
// Early escaping
$a = esc_attr( $my_class_name );

// Something naughty could happen to the string after early escaping
$a .= 'something naughty';

// Kanopi & VIP prefer to escape right at the point of output, which would be here
echo <<<HTML
<div class="test {$a}">test</div>
HTML;
```

As convenient as they are, engineers should avoid heredoc/nowdoc syntax and use traditional string concatenation & echoing instead. The HTML isn't as easy to read. But, we can be sure escaping happens right at the point of output, regardless of what happened to a variable beforehand.

```php
// Something naughty could happen to the string...
$my_class_name .= 'something naughty';

// But it doesn't matter if we're late escaping
echo '<div class="test ' . esc_attr( $my_class_name ) . '">test</div>';
```

Even better, [use WordPress' ```get_template_part()``` function as a basic template engine](https://developer.wordpress.org/reference/functions/get_template_part/#comment-2349). Make your template file consist mostly of HTML, with ```<?php ?>``` tags just where you need to escape and output. The resulting file will be as readable as a heredoc/nowdoc block, but can still perform late escaping within the template itself.

### Avoid Sessions

Sessions add extra complexity to web sites and extra burden on hosting setups. Avoid using sessions to store individual users' preferences or other data. WordPress VIP [explicitly forbids sessions in their code reviews](https://vip.wordpress.com/documentation/vip/code-review-what-we-look-for/#session_start-and-other-session-related-functions).

Instead of sessions, use cookies or client-side storage APIs if possible. In addition to keeping this data off the web servers, they empower site visitors to view and delete the data tied to their activity. Systems Engineers can configure full-page caches to ignore custom cookies so they don't interfere with caching.

If sessions must be used, create them conservatively. Don't create sessions for every visitor. Limit sessions to the smallest group that needs them: logged-in editors and admins, or visitors using a particular feature.

Sessions should never be stored in the database. This introduces extra data into a storage system that's not meant for that volume. Database session libraries also rely on PHP code which can't match the performance of PHP's native session handlers. PHP extensions for Memcache and Redis allow sessions to be stored in these in-memory datastores and are a good solution for sessions when multiple webservers are present.

<h2 id="upgrade-workflow" class="anchor-heading">WordPress & PHP Version Upgrade Workflow {% include Util/link_anchor anchor="upgrade" %}</h2>
The following procedures are what should happen in the WordPress world when there is a new PHP version, whether major or minor. This ensures adequate testing across our WordPress sites. We upgrade PHP versions proactively because we do not wish to be reactively forced into an upgrade when our hosting providers stop supporting old PHP versions and upgrade us on short notice.

Create a spreadsheet based on [the upgrade template](https://docs.google.com/spreadsheets/d/13Df3pyPwK4yWOD4P5_uH5Klrkg_rnBNTRUYXqNuFm4o/edit?pli=1#gid=0). The purpose of this spreadsheet is manifold:

* To identify whether it actually makes sense to upgrade PHP versions yet. If we encounter dozens of fatal errors in many plugins, it's likely we should just hold off.
* To identify any themes, plugins, or sites that have the potential to be especially problematic with a PHP version upgrade. For example, if a site was created in 2012 and PHP is several versions out of date, that site will probably need special care and attention.
* To gather a list of ~10 semi-representative sites that use a mix of common plugins likely to be found across multiple sites. This is so that developers can knowledge-share any particular fixes, workarounds, or other special attentions those plugins will require.

Steps for testing out a PHP version upgrade broadly/globally across many sites:

* Review the PHP manual [release documentation](https://www.php.net/releases/index.php) for any major changes to the way things work. Make a list (whether mental or physical) of issues likely to arise from language changes.
* Review the WordPress [PHP compatibility](https://make.wordpress.org/core/handbook/references/php-compatibility-and-wordpress-versions/) for any compatibility issues with new PHP versions.
* Gather a list of 10 representative Kanopi WordPress sites that use a mix of common plugins (e.g., ACF, Search and Filter, FacetWP, Gravity Forms, Ninja Forms, Yoast SEO)
* Upgrade all 10 sites locally, using Docksal.env
* Ensure debugging and debug log are enabled
* Test all 10 sites locally, using the following steps at a minimum:
  * Test ability to use WP-CLI command successfully, e.g. wp plugin list
  * View homepage and several other pages on the site, especially any pages with complex URL structures
  * Test front end ability to search -- if there are any search modifier plugins on the site, test those as well
  * Test ability to update existing post and add a new post in a standard CPT such as Posts or Pages
  * Test update/add new for any major CPTs added by plugins (e.g., Events for The Events Calendar)
  * Test update/add new for at least one custom CPT
  * Test ability to update/add new sidebar widgets, if applicable
  * Multilanguage test - does content still show in the appropriate language? Can you switch between languages? Does edit functionality work for translations?
* Make note of any issues in two places:
  * Specific to this site. These issues should be posted to a ticket created for that specific site. Issues specific to only one site (e.g., found in a custom plugin or a custom theme) should only be documented in the ticket and information specific to that site -- not the spreadsheet. These issues don’t repeat across different sites so no need to centrally log them.
  * Add to lists of issues in the global spreadsheet for things that are potentially used on other sites (e.g., if you find an issue with ACF, put it in the spreadsheet – there are other sites using ACF). The purpose of this is so that we can knowledge-share more easily.
* Compile issues into a broad human-readable overview for project managers
* Send the broad human readable overview and the spreadsheet of potentially problematic sites to the PMs -- allow project managers to decide for their individual projects if a specific site needs to be tested further
* Make a final recommendation -- e.g., "we should all start upgrading" or "we should wait a little while until more things become PHP compatible" based on your findings.

Steps for developers upgrading a PHP version upgrade:

* Upgrade site using Docksal.env PHP version
* Ensure debugging and debug log are enabled
* For individual sites: developers may wish to start a separate local environment. E.g., if your site is pen_org, create pen_org_php8. This is so that you can still work on any other tasks in parallel with the PHP version upgrade. It keeps parity with the version of PHP actually on production, and also minimizes the amount of time spent starting and restarting your project.
* Fix any PHP fatal errors arising from the new PHP version. Warnings should also be fixed wherever possible to keep logs clean.
*  We have found in the past that some plugins and similar are less compatible. These obviously cannot be fixed as it is third-party code. Plugin-based warnings are skippable and do not need to be fixed. We can wait until the plugin author fixes their code.
