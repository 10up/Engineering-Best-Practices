Data migrations are a necessary but often feared part of building applications on the web. Migrations can, and typically are, difficult, but if planned properly, they can be fairly painless. The following are some general guidelines to keep in mind when dealing with a migration. Note that this is not a how-to guide on doing a migration, since all migrations are unique, but these are some general guidelines to follow.

### Migration Plans

The first step in any migration project is to document a detailed plan. A typical migration plan is expected to outline:

* How the content and data will be “pulled” out of the originating site (direct database connection, XML or WXR export, flat files such as SQL scripts, scraper, etc.). For many migrations, a SQL dump is used to move the data to a migration server where we can more easily handle it;
* Scripting requirements. Many migrations need [WP-CLI](http://wp-cli.org/) scripts for mapping data;
* How long the migration is expected to run;
* How the data and content will be mapped to the new site’s information architecture;
* The impact of the migration on any production editorial processes (i.e. content freezes, differential migration requirements);
* Potential “gotchas” - or risks - to watch out for;
* Staffing implications. What parties need to be available during the migration;
* How will migrated content be reviewed for accuracy;
* Making changes to data structure can influence site SEO. Proper redirects mitigate most of this, but this should be thoroughly accounted for in the plan;
* How will backups be restored. How will a failed migration be handled.


Make sure to have the plan peer reviewed by *at least* one other engineer.

### Tips to speed up migrations

* __Separate tasks.__

	Prioritize faster tasks. This doesn’t necessarily speed up the total execution time, but will get some data in place sooner, meaning it can be reviewed more quickly to ensure the migration is on track. Importing media files, and fetching assets from a remote site tend to be the slowest tasks.

* __Use a dedicated migration server.__

	A separate server dedicated solely to migration provides system resources for a faster migration that isn’t influenced by other applications.

* __Free up memory.__

	During migration script execution, make sure to periodically free up memory. A typical function used at 10up is:

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

* __Defer counting.__

	When migrating taxonomies, call `wp_defer_term_counting( true )` before, and then `wp_defer_term_counting( false )` afterwards. This technique also applies to comments, by using `wp_defer_comment_counting( true )`.

* __Use helpful constants that eliminate unneeded processing.__

	Setting `define( 'WP_POST_REVISIONS', 0 )` can cut down significantly on memory usage.

* __Use PHP7__
	
	If PHP 7 is an option, use it.

### Requirements for a successful migration

* __Test all migration scripts.__
	
	Migration scripts must be tested repeatedly on a local development environment, staging, and pre-production (if available) before being run on production, so that issues can be safely corrected. It’s always better to write and test scripts iteratively, to minimize the complexity involved in troubleshooting and fix bad assumptions or dependencies early in the process. As with the migration plan, have another engineer review all script code before running.

* __Be mindful of external integrations.__

	It’s *critically important* to make sure migration scripts don’t trigger unintended external integrations. It’s common in WordPress development to tie functionality to hooks that fire when content is created and/or saved, which is part of almost every data migration. A migration script that triggers these hooks might trigger a variety of unintended actions, like publishing content to Facebook or Twitter, or firing off emails to site subscribers. In this latter case, hundreds, if not thousands, of emails could flood subscribers’ inboxes as content is migrated, possibly even during a test migration to a development site. *At best, this can be extremely embarrassing; at worst, this could do harm to a customer and even be considered negligent.*
	
	One way to prevent some unintended triggers is by checking the `WP_IMPORTING` constant. A migration script *must* set this constant, `define( 'WP_IMPORTING', true )`, as well engineered integrations will check for that before executing.

* __Editorial data review.__

	As engineers, it’s easy to look at data and say “this looks right”. However, editors and those deeply involved with site management have a much closer relationship to the content. Have a member of the site editorial team check posts to make sure they have correct titles, content, authors, dates, and other related metadata.

* __Coordinate with the host.__

	When running a migration on an externally hosted server, make sure the host is aware. Most migrations require significant server resources, and could impact other hosted applications or trigger flags.

* __Make specific plans for content stored in the file system (i.e. site media).__

	Media, like images, videos, or audio files typically take longer to migrate, as they have to be downloaded to the new site, and sometimes require more carefully considered content transformation (e.g. changing URLs in the content). If there is an unusually large volume of attached media to move, consider offloading processing using tools like [Gearman](https://github.com/10up/WP-Gears) to process multiple files at once.

* __Doublecheck author metadata.__

	Always make sure that authors are fully migrated and assigned to the correct content. Ensure only a single account is made per author.Be careful to consider whether the site supports assigning multiple authors to a single post.

* __Save a piece of meta with each migrated piece of content referring back to the original content.__

	This allows all migrated content to be found easily (a typical use case is deleting all migrated content in preparation for re-running the migration scripts). If, after a successful production migration is completed, a piece of data is found that wasn’t originally included in the planning and now needs to be brought over, new migration scripts can be written to interact with the saved meta.
