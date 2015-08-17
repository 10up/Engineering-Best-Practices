### Performance

Writing performant code is absolutely critical, especially at the enterprise level. There are a number of strategies and best practices we must employ to ensure our code is optimized for high-traffic situations.

#### Efficient Database Queries

When querying the database in WordPress, you should generally use a [```WP_Query```](http://codex.wordpress.org/Class_Reference/WP_Query) object. ```WP_Query``` objects take a number of useful arguments and do things behind-the-scenes that other database access methods such as [```get_posts()```](https://developer.wordpress.org/reference/functions/get_posts/) do not.

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

    This will tell WordPress not to run ```SQL_CALC_FOUND_ROWS``` on the SQL query drastically speeding up your query. ```SQL_CALC_FOUND_ROWS``` calculates the total number of rows in your query which is required to know the total amount of "pages" for pagination.

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
    
* A [taxonomy](http://codex.wordpress.org/Taxonomies) is a tool that lets us group or classify posts.

    [Post meta](http://codex.wordpress.org/Custom_Fields) lets us store unique information about specific posts. As such the way post meta is stored does not facilitate efficient post lookups. Generally, looking up posts by post meta should be avoided (sometimes it can't). If you have to use one, make sure that it's not the main query and that it's cached.

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

##### WP\_Query vs. get\_posts() vs. query\_posts()
As outlined above, `get_posts()` and `WP_Query`, apart from some slight nuances, are quite similar. Both have the same performance cost (minus the implication of skipping filters): the query performed.

[`query_posts()`](https://developer.wordpress.org/reference/functions/query_posts/), on the other hand, behaves quite differently than the other two and should almost never be used. Specifically:

* It creates a new `WP_Query` object with the parameters you specify.
* It replaces the existing main query loop with a new instance of `WP_Query`.

As noted in the [WordPress Codex (along with a useful query flow chart)](http://codex.wordpress.org/Function_Reference/query_posts), `query_posts()` isn't meant to be used by plugins or themes. Due to replacing and possibly re-running the main query, `query_posts()` is not performant and certainly not an acceptable way of changing the main query.

#### Caching

Caching is simply the act of storing computed data somewhere for later use, and is an incredibly important concept in WordPress. There are different ways to employ caching, and often multiple methods will be used.

##### The "Object Cache"

Object caching is the act of caching data or objects for later use. In the context of WordPress, objects are cached in memory so they can be retrieved quickly.

In WordPress, the object cache functionality provided by [```WP_Object_Cache```](https://developer.wordpress.org/reference/classes/wp_object_cache/), and the [Transient API](https://codex.wordpress.org/Transients_API) are great solutions for improving performance on long-running queries, complex functions, or similar.

On a regular WordPress install, the difference between transients and the object cache is that transients are persistent and would write to the options table, while the object cache only persists for the particular page load.

On environments with a persistent caching mechanism (i.e. [Memcache](http://memcached.org/), [Redis](http://redis.io/), or similar) enabled, the transient functions become wrappers for the normal ```WP_Object_Cache``` functions. The objects are identically stored in the object cache and will be available across page loads.

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
            wp_cache_set( 'prefix_top_commented_posts', $top_commented_posts, 'top_posts', 5 * MINUTE_IN_SECONDS )
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
 * @param bool $force_refresh Optional. Whether to force the cache to be refreshed.
                              Default false.
 * @return array|WP_Error Array of WP_Post objects with the highest comment counts,
 *                        WP_Error object otherwise.
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
            wp_cache_set( 'prefix_top_commented_posts', $top_commented_posts, 'top_posts' )
        }
    }
    return $top_commented_posts;
}
?>
```

With this implementation, you can keep the cache object forever and don't need to add an expiration for the object as you would create a new cache entry whenever it is required. Just keep in mind that some external caches (like Memcache) can invalidate cache objects without any input from WordPress.

For that reason, it's best to make the code that repopulates the cache available for many situations.

In some cases, it might be necessary to create multiple objects depending on the parameters a function is called with. In these cases, it's usually a good idea to create a cache key which includes a representation of the variable parameters. A simple solution for this would be appending an md5 hash of the serialized parameters to the key name.

##### Page Caching

Page caching in the context of web development refers to storing a requested location's entire output to serve in the event of subsequent requests to the same location.

[Batcache](https://wordpress.org/plugins/batcache) is a WordPress plugin that uses the object cache (often Memcache in the context of WordPress) to store and serve rendered pages. It can also optionally cache redirects. It's not as fast as some other caching plugins, but it can be used where file-based caching is not practical or desired.

Batcache is aimed at preventing a flood of traffic from breaking your site. It does this by serving old (5 minute max age by default, but adjustable) pages to new users. This reduces the demand on the web server CPU and the database. It also means some people may see a page that is a few minutes old. However this only applies to people who have not interacted with your website before. Once they have logged-in or left a comment, they will always get fresh pages.

Although this plugin has a lot of benefits, it also has a couple of code design requirements:

* As the rendered HTML of your pages might be cached you cannot rely on server side logic related to ```$_SERVER```, ```$_COOKIE``` or other values that are unique to a particular user.
* You can however implement cookie or other user based logic on the front-end (eg. with JavaScript)

Batcache does not cache logged in users (based on WordPress login cookies), so keep this in mind the performance implications for subscription sites (like BuddyPress). Batcache also treats the query string as part of the URL which means the use of query strings for tracking campaigns (common with Google Analytics) can render page caching ineffective.  Also beware that while WordPress VIP uses batcache, there are specific rules and conditions on VIP that do not apply to the open source version of the plugin.

There are other popular page caching solutions such as the W3 Total Cache plugin, though we generally do not use them for a variety of reasons.

##### AJAX Endpoints

AJAX stands for Asynchronous JavaScript and XML. Often, we use JavaScript on the client-side to ping endpoints for things like infinite scroll.

WordPress [provides an API](http://codex.wordpress.org/AJAX_in_Plugins) to register AJAX endpoints on ```wp-admin/admin-ajax.php```. However, WordPress does not cache queries within the administration panel for obvious reasons. Therefore, if you send requests to an admin-ajax.php endpoint, you are bootstrapping WordPress and running un-cached queries. Used properly, this is totally fine. However, this can take down a website if used on the frontend.

For this reason, front-facing endpoints should written by using the [Rewrite Rules API](http://codex.wordpress.org/Rewrite_API) and hooking early into the WordPress request process.

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

##### Cache Remote Requests

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
    if ( false === ( $posts = wp_cache_get( 'prefix_other_blog_posts' ) ) {

        $request = wp_remote_get( ... );
        $posts = wp_remote_retrieve_body( $request );

        wp_cache_set( 'prefix_other_blog_posts', $posts, '', HOUR_IN_SECONDS );
    }
    return $posts;
}
?>
```

```prefix_get_posts_from_other_blog()``` can be called to get posts from a third-party and will handle caching internally.

#### Appropriate Data Storage

Utilizing built-in WordPress APIs we can store data in a number of ways.

We can store data using options, post meta, post types, object cache, and taxonomy terms.

There are a number of performance considerations for each WordPress storage vehicle:

* [Options](http://codex.wordpress.org/Options_API) - The options API is a simple key-value storage system backed by a MySQL table. This API is meant to store things like settings and not variable amounts of data.
* [Post Meta or Custom Fields](http://codex.wordpress.org/Custom_Fields) - Post meta is an API meant for storing information specific to a post. For example, if we had a custom post type, "Product", "serial number" would be information appropriate for post meta. Because of this, it usually doesn't make sense to search for groups of posts based on post meta
* [Taxonomies and Terms](http://codex.wordpress.org/Taxonomies) - Taxonomies are essentially groupings. If we have a classification that spans multiple posts, it is a good fit for a taxonomy term. For example, if we had a custom post type, "Car", "Nissan" would be a good term since multiple cars are made by Nissan. Taxonomy terms can be efficiently searched across as opposed to post meta.
* [Custom Post Types](http://codex.wordpress.org/Post_Types) - WordPress has the notion of "post types". "Post" is a post type which can be confusing. We can register custom post types to store all sorts of interesting pieces of data. If we have a variable amount of data to store such as a product, a custom post type might be a good fit.
* [Object Cache](http://codex.wordpress.org/Class_Reference/WP_Object_Cache) - See caching section.

#### Database Writes

Writing information to the database is at the core of any website you build. Here are some tips:

* Generally, do not write to the database on frontend pages as doing so can result in major performance issues and race conditions.

* When multiple threads (or page requests) read or write to a shared location in memory and the order of those read or writes is unknown, you have what is known as a [race condition](http://en.wikipedia.org/wiki/Race_condition).

* Store information in the correct place. See the "Appropriate Data Storage" section.

* Certain options are "autoloaded" or put into the object cache on each page load. When [creating or updating options](http://codex.wordpress.org/Options_API), you can pass an ```$autoload``` argument to [```add_option()```](https://developer.wordpress.org/reference/functions/add_option/). If your option is not going to get used often, it probably shouldn't be autoloaded. Unfortunately, [```update_option()```](https://developer.wordpress.org/reference/functions/update_option/) automatically sets ```autoload``` to ```true``` so you have to use a combination of [```delete_option()```](https://developer.wordpress.org/reference/functions/delete_option/) and ```add_option()``` to accomplish this.

<h3 id="design-patterns">Design Patterns {% include Util/top %}</h3>

Using a common set of design patterns while working with PHP code is the easiest way to ensure the maintainability of a project. This section addresses standard practices that set a low barrier for entry to new developers on the project.

#### Namespacing

All functional code should be properly namespaced. We do this to logically organize our code and to prevent collisions in the global namespace. Generally, this means using a PHP ```namespace``` identifier at the top of included files:

```php
<?php
namespace tenup\Utilities\API;

function do_something() {
  // ...
}
```

If the code is for general release to the WordPress.org theme or plugin repositories, the [minimum PHP compatibility](https://wordpress.org/about/requirements/) of WordPress itself must be met. Unfortunately, PHP namespaces are not supported in version < 5.3, so instead, a class would be used to wrap static functions to serve as a _pseudo_ namespace:

```php
<?php
/**
 * Namespaced class name example.
 */
class Tenup_Utilities_API {
	public static function do_something() {
		// ...
	}
}
```

The similar structure of the namespace and the static class will allow for simple onboarding to either style of project (and a quick upgrade to PHP namespaces if and when WordPress raises its minimum version requirements).

Anything declared in the global namespace, including a namespace itself, should be written in such a way as to ensure uniqueness. A namespace like ```tenup``` is (most likely) unique; ```theme``` is not. A simple way to ensure uniqueness is to prefix a declaration with unique prefix.

#### Object Design

Firstly, if a function is not specific to an object, it should be included in a functional <a href="#namespacing">namespace</a> as referenced above.

Objects should be well-defined, atomic, and fully documented in the leading docblock for the file. Every method and property within the object must themselves be fully-documented, and relate to the object itself.

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

#### Visibility

In terms of [Object-Oriented Programming](http://en.wikipedia.org/wiki/Object-oriented_programming) (OOP), public properties and methods should obviously be `public`. Anything intended to be private should actually be specified as `protected`. There should be no `private` fields or properties without well-documented and agreed-upon rationale.

#### Structure and Patterns

* Singletons are not advised. There is little justification for this pattern in practice and they cause more maintainability problems than they fix.
* Class inheritance should be used where possible to produce [DRY](http://en.wikipedia.org/wiki/Don't_repeat_yourself) code and share previously-developed components throughout the application.
* Global variables should be avoided. If objects need to be passed throughout the theme or plugin, those objects should either be passed as parameters or referenced through an object factory.
* Hidden dependencies (API functions, super-globals, etc) should be documented in the docblock of every function/method or property.
* Avoid registering hooks in the __construct method. Doing so tightly couples the hooks to the instantiation of the class and is less flexible than registering the hooks via a separate method. Unit testing becomes much more difficult as well.

<h3 id="security">Security {% include Util/top %}</h3>

Security in the context of web development is a huge topic. This section only addresses some of the things we can do at the server-side code level.

#### Input Validation and Sanitization

To validate is to ensure the data you've requested of the user matches what they've submitted. Sanitization is a broader approach ensuring data conforms to certain standards such as an integer or HTML-less text. The difference between validating and sanitizing data can be subtle at times and context-dependant.

Validation is always preferred to sanitization. Any non-static data that is stored in the database must be validated or sanitized. Not doing so can result in creating potential security vulnerabilities.

WordPress has a number of [validation and sanitization functions built-in](http://codex.wordpress.org/Validating_Sanitizing_and_Escaping_User_Data#Validating:_Checking_User_Input).

Sometimes it can be confusing as to which is the most appropriate for a given situation. Other times, it's even appropriate to write our own sanitization and validation methods.

Here's an example of validating an integer stored in post meta:

```php
<?php
if ( ! empty( $_POST['user_id'] ) ) {
    update_post_meta( $post_id, 'key', absint( $_POST['user_id'] ) );
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

##### Raw SQL Preparation and Sanitization

There are times when dealing directly with SQL can't be avoided. WordPress provides us with [```$wpdb```](http://codex.wordpress.org/Class_Reference/wpdb).

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

$wpdb->insert( $wpdb->posts, array( 'post_content' => wp_kses_post( $post_content ), array( '%s' ) );
?>
```

```$wpdb->insert()``` creates a new row in the database. ```$post_content``` is being passed into the ```post_content``` column. The third argument lets us specify a format for our values ```sprintf()``` style. Forcing the value to be a string using the ```%s``` specifier prevents many SQL injections attacks. However, ```wp_kses_post()``` still needs to be called on ```$post_content``` as someone could inject harmful JavaScript otherwise.

#### Escape or Validate Output

To escape is to ensure data conforms to specific standards before being passed off. Validation, again, ensures that data matches what is to be expected in a much stricter way. Any non-static data outputted to the browser must be escaped or validated.

WordPress has a number of core functions that can be leveraged for escaping. At 10up, we follow the philosophy of *late escaping*. This means we escape things just before output in order to reduce missed escaping and improve code readability.

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
<script>
if ( document.cookie.indexOf( 'cookie_key' ) >= 0 ) {
    document.getElementById( 'test' ).getAttribute( 'href' ) = '<?php echo esc_js( get_post_meta( $post_id, 'key', true ) ); ?>';
}
</script>
```

[```esc_js()```](https://developer.wordpress.org/reference/functions/esc_js/) ensures that whatever is returned is safe to be printed within a JavaScript string.

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

```wp_kses_*``` functions should be used sparingly as they have bad performance due to a large number of regular expression matching attempts. If you find yourself using ```wp_kses_*```, it's worth evaluating what you are doing as whole.

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

There are many escaping situations not covered in this section. Everyone should explore the [WordPress codex article](http://codex.wordpress.org/Validating_Sanitizing_and_Escaping_User_Data#Escaping:_Securing_Output) on escaping output to learn more.

#### Nonces

In programming, a nonce, or number used only once, is a tool used to prevent [CSRF](http://en.wikipedia.org/wiki/Cross-site_request_forgery) or cross-site request forgery.

The purpose of a nonce is to make each request unique so an action cannot be replayed.

WordPress' [implementation](http://codex.wordpress.org/WordPress_Nonces) of nonces are not strictly numbers used once, though they serve an equal purpose.

The literal WordPress definition of nonces is "A cryptographic token tied to a specific action, user, and window of time.". This means that while the number is not a true nonce, the resulting number *is* specifically tied to the action, user, and window of time for which it was generated.

Let's say you want to trash a post with `ID` 1. To do that, you might visit this URL: ```http://example.com/wp-admin/post.php?post=1&action=trash```

Since you are authenticated and authorized, an attacker could trick you into visiting a URL like this: ```http://example.com/wp-admin/post.php?post=2&action=trash```

For this reason, the trash action requires a valid WordPress nonce.

After visiting ```http://example.com/wp-admin/post.php?post=1&action=trash&_wpnonce=b192fc4204```, the same nonce will not be valid in ```http://example.com/wp-admin/post.php?post=2&action=trash&_wpnonce=b192fc4204```.

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

<h3 id="code-style">Code Style & Documentation {% include Util/top %}</h3>

We follow the official WordPress [coding](http://make.wordpress.org/core/handbook/coding-standards/php/) and [documentation](https://make.wordpress.org/core/handbook/inline-documentation-standards/php-documentation-standards/) standards. The [WordPress Coding Standards for PHP_CodeSniffer](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards) will find many common violations and flag risky code for manual review.

That said, at 10up we highly value verbose commenting/documentation throughout any/all code, with an emphasis on docblock long descriptions which state 'why' the code is there and 'what' exactly the code does in human-readable prose. As a general rule of thumb; a manager should be able to grok your code by simply reading the docblock and inline comments.

Example:

```php
<?php
/**
 * Hook into WordPress to mark specific post meta keys as protected
 *
 * Post meta can be either public or protected. Any post meta which holds 
 * **internal or read only** data should be protected via a prefixed underscore on
 * the meta key (ex: _my_post_meta) or by indicating it's protected via the 
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
        'and_another_keta_key',
    );

    // Set the protected var to true when the current meta key matches
    // one of the meta keys in our array of keys to be protected
    if ( in_array( $current_meta_key, $meta_keys_to_be_protected ) ) {
        $protected = true;
    }

    // Return the (possibly) modified $protected variable
    return $protected;
}
?>
```

<h3 id="unit-testing">Unit and Integration Testing {% include Util/top %}</h3>

Unit testing is the automated testing of units of source code against certain assertions. The goal of unit testing is to write test cases with assertions that test if a unit of code is truly working as intended. If an assertion fails, a potential issue is exposed, and code needs to be revised.

By definition, unit tests do not have dependencies on outside systems; in other words, only your code (a single unit of code) is being tested. Integration testing works similarly to unit tests but assumptions are tested against systems of code, moving parts, or an entire application. The phrases unit testing and integration testing are often misused to reference one another especially in the context of WordPress.

At 10up, we generally employ unit and integration tests only when building applications that are meant to be distributed. Building tests for client themes does usually not offer a huge amount of value (there are of course exceptions to this). When we do write tests, we use PHPUnit which is the WordPress standard library.

Read more at the [PHPUnit homepage](https://phpunit.de/) and [automated testing for WordPress](http://make.wordpress.org/core/handbook/automated-testing/)

<h3 id="libraries">Libraries and Frameworks {% include Util/top %}</h3>

Generally, we do not use PHP frameworks or libraries that do not live within WordPress for general theme and plugin development. WordPress APIs provide us with 99 percent of the functionality we need from database management to sending emails. There are frameworks and libraries we use for themes and plugins that are being distributed or open-sourced to the public such as PHPUnit.
