Data migrations are a necessary but often feared part of building things on the web. Migrations can, and typically are, difficult, but if planned properly, they can be fairly painless. The following are some general guidelines to keep in mind when dealing with a migration. Note that this is not a how-to guide on doing a migration, since all migrations are unique, but these are some general guidelines to follow.

### Migration Plan

The first step in any migration should be to create a migration plan. This plan will be built on information obtained from analyzing the site you're migrating. This could be a migration from one WordPress site to another, with minimal data changes, or it could be from a completely custom CMS into WordPress. In any case, we need to figure out where the data lives, how it's currently stored, and how that data is going to map into the new site. In almost all cases, this will involve getting the actual data to be migrated (usually a database dump).

Once the data has been analyzed, we can use that information to start writing our migration plan. This plan will contain things like what steps we will be running, how long we expect the migration to take, a mapping of the data from the old site to the new one (custom post types, custom taxonomies, how much data there is, etc) and any gotchas we want to keep an eye on (expounded upon below). This migration plan will heavily influence the next steps. Make sure this migration plan is reviewed by at least one other engineer, incorporating any feedback they might have. At 10up, plans are required for every migration.

### Writing Migration Scripts

Now that we have a solid migration plan in place, we are ready to actually write the scripts that will handle the migration. All migrations will vary heavily at this step. Sometimes we can get WXR files and just use the WordPress importer (typically using [WP CLI](http://wp-cli.org/commands/import/)) to handle everything we need. Other times we'll use the WordPress Importer then write a script to modify data once it's in WordPress. Other times we'll write scripts that handle the entire migration process for us.

All of these decisions should be part of the migration plan we put together, so at this point, we know exactly what we are going to do, and we can start work accordingly. 10up will generally use [WP CLI](http://wp-cli.org/) to power these scripts, which gives us great flexibility on what we can do, what output we can show, and typically you'll have a lot less issues with performance, like memory limits and timeouts.

### Thou Shalt Not Forget

The following are some general things to keep in mind when doing these migrations. Note that not all will apply in every scenario and there are items missing from this list, but this gives a good general overview of things to keep in mind.

* *Test all migration scripts*

	This probably goes without saying but migrations should be run multiple times: locally, staging, preproduction (if available), before it's ever run on production. There will inevitably be issues that need to be fixed, so the more the migration process is tested, the more likely these issues are found and fixed before it's run on production. It's always better to write and test iteratively, so any potentially issues can be found and fixed sooner.

	 * In the same vein as this, make sure all scripts are code reviewed before running on stage/preprod/prod.

* *Review data*

	Once data has been migrated to an accessible server (typically stage), all data should be heavily reviewed to make sure it was migrated correctly. This means checking to make sure posts have correct titles, correct content, correct authors, correct dates, etc. Normally the client will be helping significantly with this step, as they are the ones most familiar with the content.

* *Schedule with host*

	When running a migration on a hosted server, make sure the host is aware when these are going to be run. Most migrations take up quite a few resources, so planning this in advance, and making sure the host is okay with it, is always a good idea. It's good to work with a host weeks in advance to plan a migration.

* *Images (and other media)*

	Media, usually images but also videos or audio, should be considered when putting together your migration plan. These types of items typically take longer to migrate, as they have to be downloaded to the new site. Having a plan in place to handle this is important.

	Sometimes media can be left as-is, meaning, for instance, any image that's referenced somewhere can stay as-is and doesn't need to be moved over. But often we'll want all media brought over to the new site. In this case, if the amount of total media items is small, this can be done using core WordPress functions. If the amount of media is great, this can significantly slow down the migration process and sometimes crash it all together. In this scenario, looking into options to offload this processing is usually the way to go (something like using [Gearman](http://gearman.org/) to process multiple media items at once).

* *Redirects*

	In some cases, the data structure from the old site to the new changes in such a way that new URLs are needed. Sometimes this is on purpose, sometimes it's necessary because of some data changes. In any case, these need to be accounted for and the client consulted so we can add proper redirects, so any links to the old content will redirect to the new content. Failure to properly handle redirects can have disasterous search engine indexing consequences. Always work with the client closely on redirect plans.
	
	There are multiple ways to handle redirects, whether these are set on the server level, whether they are set using a [plugin](https://wordpress.org/plugins/safe-redirect-manager/) or sometimes a custom approach is needed. Generally it's good practice to keep track of all needed redirects as the migration runs, so by the time the migration is done, we have a list of all needed redirects. This can be achieved multiple ways but one way would be a custom mapping table, that maps old content to new content. However these are saved though, these then can be implemented with our chosen approach.

* *Authors*

	We always need to make sure authors are brought over and assigned correctly. When creating authors, only create them once, so we don't end up with duplicate authors. Once an author has been brought over the first time, check for and re-use that author each time we need it in the future. Some platforms have the ability to set multiple authors on a post, so make sure there's a solution figured out for that if needed.

### Potential Side Effects

Even the most carefully planned migration can have issues. The following are some things that might occur if they're not planned for and tested.

* *Missing data*

	There will be occasions when some data can't be found when trying to migrate it. Typically this will be media items, like images. Having a plan in place to deal with any content that can't be found will ensure your scripts don't fail.

* *SEO*

	When making changes to data structure, there's always a possibility to negatively impact SEO. If proper thought is put into redirects, as mentioned above, that should help mitigate most of this. But definitely something that should be thought through and accounted for.

* *Social*

	One thing to make sure of when running migrations is to not trigger any social services that might be set up. This includes sending posts to Facebook, Twitter or email. We don't want to spam subscribers with hundreds, if not thousands of items all in a row, as those items are migrated in. There are multiple ways to prevent this from happening and will depend heavily on how the site is set up (i.e. how these social services are powered). Make sure as part of the migration plan you account for this.

* *Time*

	Migrations tend to take a lot of time, from putting together a good migration plan, writing the migration scripts, testing those scripts, fixing issues found and then finally running the migration on production. Always make sure there's enough time estimated for this in a project and enough time set aside to get all this done within the required time frame.

* *Backups*

	As has been hinted at a few times in this guide, migrations tend to never work right the very first time, and they end up needing to be run over and over, with tweaks in between to get to the end goal. Always keep a backup of the original data, so at any point we can re-run a migration with a fresh data set. Also, usually it's a good idea to save a piece of meta with any content that gets migrated. This allows us at any point to find all migrated content and do something with that data (a typical use-case would be deleting all migrated content to be able to re-run the migration).
	
	Also, inevitably there will come a time when after a successful production migration has been done, some other piece of data is found that wasn't originally thought of and now needs to be brought over. As long as an original data source was kept (typically a database backup), new migration scripts can be written and run to get the missing content.

### Tips to speed up migrations

As mentioned above, migrations tend to take a long time to run. The following are some suggestions on how to speed this process up.

* *Separate tasks*

	Often a good idea to separate quick tasks from longer running tasks. This doesn't necessarily speed up the entire process but can make it feel faster and will get most of the data in place sooner, meaning it can be reviewed sooner and verify sooner if any issues exist. Quick tasks will be things like importing just text content, especially something stored locally. Slower/longer running tasks will be those dealing with media items, like fetching images from a remote site.

* *Migration server*

	If possible, setup a separate server just to handle the migration process. This makes sure you're not bogging down any other sites that might run on your stage/preprod/production servers and allows you to give this server the proper resources for running a migration.

* *Free up memory*

	If iterating through lots of items, which is typically done in most migrations, make sure to periodically free up memory. A typical function used at 10up looks like this:

```php
<?php
function stop_the_insanity() {
	global $wpdb, $wp_object_cache;

	$wpdb->queries = array();
	
	if ( is_object( $wp_object_cache ) ) {
		$wp_object_cache->group_ops      = array();
		$wp_object_cache->stats          = array();
		$wp_object_cache->memcache_debug = array();
		$wp_object_cache->cache          = array();

		if ( method_exists( $wp_object_cache, '__remoteset' ) ) {
			$wp_object_cache->__remoteset();
		}
	}
}
```

* Defer counting

	If migrating taxonomies, you can call `wp_defer_term_counting( true )` before, and then after call `wp_defer_term_counting( false )`. This will speed up the process of importing taxonomy items. Can also do a similar thing if importing comments: `wp_defer_comment_counting( true )`.

* Helpful constants

	Setting `define( 'WP_POST_REVISIONS', 0 )` can cut down significantly on memory usage. Setting `define( 'WP_IMPORTING', true )` can also decrease memory usage slightly, and is often used in various plugins to stop functionality from running, like mentioned in the Social section above. 

* Use PHP7 when possible
