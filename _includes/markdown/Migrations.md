Data migrations are a necessary but often feared part of building applications on the web. Migrations can, and typically are, difficult, but if planned properly, they can be fairly painless. The following are some general guidelines to keep in mind when dealing with a migration. Note that this is not a how-to guide on doing a migration, since all migrations are unique, but these are some general guidelines to follow.

## Migration Plan

The first step in any migration project is to document a detailed plan. A typical migration plan is expected to outline:

* How the content and data will be “pulled” out of the originating site (direct database connection, XML or WXR export, flat files such as SQL scripts, scraper, etc.). For many migrations, a SQL dump is used to move the data to a migration server where we can more easily handle it;
* Scripting requirements. Many migrations need [WP-CLI](https://wp-cli.org/) scripts for mapping data;
* How long the migration is expected to run;
* How the data and content will be mapped to the new site’s information architecture;
* The impact of the migration on any production editorial processes (i.e. content freezes, differential migration requirements);
* Potential “gotchas” - or risks - to watch out for;
* Staffing implications. What parties need to be available during the migration;
* How will migrated content be reviewed for accuracy;
* Making changes to data structure can influence site SEO. Proper redirects mitigate most of this, but this should be thoroughly accounted for in the plan;
* How will backups be restored. How will a failed migration be handled.

Make sure to have the plan peer reviewed by *at least* one other engineer.

## Writing Migration Scripts

Now that we have a solid migration plan in place, we are ready to actually write the scripts that will handle the migration. All migrations will vary heavily at this step. Sometimes we can get WXR files and just use the WordPress importer (typically using [WP CLI](https://wp-cli.org/commands/import/)) to handle everything we need. Other times we'll use the WordPress Importer then write a script to modify data once it's in WordPress. Other times we'll write scripts that handle the entire migration process for us.

All of these decisions should be part of the migration plan we put together, so at this point, we know exactly what we are going to do, and we can start work accordingly. WisdmLabs will generally use [WP CLI](https://wp-cli.org/) to power these scripts, which gives us great flexibility on what we can do, what output we can show, and typically you'll have a lot less issues with performance, like memory limits and timeouts.

## Thou Shalt Not Forget

The following are some general things to keep in mind when doing these migrations. Note that not all will apply in every scenario and there are items missing from this list, but this gives a good general overview of things to keep in mind.

* *Test all migration scripts*

	This probably goes without saying but migrations should be run multiple times: locally, staging, preproduction (if available), before it's ever run on production. There will inevitably be issues that need to be fixed, so the more the migration process is tested, the more likely these issues are found and fixed before it's run on production. It's always better to write and test iteratively, so any potential issues can be found and fixed sooner.

	 * In the same vein as this, make sure all scripts are code reviewed before running on stage/preprod/prod.

* *Review data*

	Once data has been migrated to an accessible server (typically stage), all data should be heavily reviewed to make sure it was migrated correctly. This means checking to make sure posts have correct titles, correct content, correct authors, correct dates, etc. Normally the client will be helping significantly with this step, as they are the ones most familiar with the content.

* *Schedule with host*

	When running a migration on a hosted server, make sure the host is aware when these are going to be run. Most migrations take up quite a few resources, so planning this in advance, and making sure the host is okay with it, is always a good idea. It's good to work with a host weeks in advance to plan a migration.

* *Images (and other media)*

	Media, usually images but also videos or audio, should be considered when putting together your migration plan. These types of items typically take longer to migrate, as they have to be downloaded to the new site. Having a plan in place to handle this is important.

	Sometimes media can be left as-is, meaning, for instance, any image that's referenced somewhere can stay as-is and doesn't need to be moved over. But often we'll want all media brought over to the new site. In this case, if the amount of total media items is small, this can be done using core WordPress functions. If the amount of media is great, this can significantly slow down the migration process and sometimes crash it all together. In this scenario, looking into options to offload this processing is usually the way to go (something like using [Gearman](http://gearman.org/) to process multiple media items at once).

* *Redirects*

	In some cases, the data structure from the old site to the new changes in such a way that new URLs are needed. Sometimes this is on purpose, sometimes it's necessary because of some data changes. In any case, these need to be accounted for and the client consulted so we can add proper redirects, so any links to the old content will redirect to the new content. Failure to properly handle redirects can have disastrous search engine indexing consequences. Always work with the client closely on redirect plans.

	There are multiple ways to handle redirects, whether these are set on the server level, whether they are set using a [plugin](https://wordpress.org/plugins/safe-redirect-manager/) or sometimes a custom approach is needed. Generally it's good practice to keep track of all needed redirects as the migration runs, so by the time the migration is done, we have a list of all needed redirects. This can be achieved in multiple ways but one way would be a custom mapping table, that maps old content to new content. However these are saved though, they can then be implemented with our chosen approach.

* *Authors*

	We always need to make sure authors are brought over and assigned correctly. When creating authors, only create them once, so we don't end up with duplicate authors. Once an author has been brought over the first time, check for and re-use that author each time we need it in the future. Some platforms have the ability to set multiple authors on a post, so make sure there's a solution figured out for that if needed.

## Potential Side Effects

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

## Tips to speed up migrations

* __Separate tasks.__

	Prioritize faster tasks. This doesn’t necessarily speed up the total execution time, but will get some data in place sooner, meaning it can be reviewed more quickly to ensure the migration is on track. Importing media files, and fetching assets from a remote site tend to be the slowest tasks.

* __Use a dedicated migration server.__

	A separate server dedicated solely to migration provides system resources for a faster migration that isn’t influenced by other applications.

* __Free up memory.__

	During migration script execution, make sure to periodically free up memory. A typical function used at WisdmLabs is:

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

	Media, like images, videos, or audio files typically take longer to migrate, as they have to be downloaded to the new site, and sometimes require more carefully considered content transformation (e.g. changing URLs in the content). If there is an unusually large volume of attached media to move, consider offloading processing using tools like [Gearman](https://github.com/WisdmLabs/WP-Gears) to process multiple files at once.

* __Doublecheck author metadata.__

	Always make sure that authors are fully migrated and assigned to the correct content. Ensure only a single account is made per author. Be careful to consider whether the site supports assigning multiple authors to a single post.

* __Save a piece of meta with each migrated piece of content referring back to the original content.__

	This allows all migrated content to be found easily (a typical use case is deleting all migrated content in preparation for re-running the migration scripts). If, after a successful production migration is completed, a piece of data is found that wasn’t originally included in the planning and now needs to be brought over, new migration scripts can be written to interact with the saved meta.
