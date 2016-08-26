Data migrations are a necessary, but often feared part of building things on the web. Migrations can, and typically are, difficult, but if planned properly, they can be fairly painless. The following are some general guidelines to keep in mind when dealing with a migration. Note this is not a how-to guide on doing a migration, since typically all migrations are unique, but this is some general guidelines to follow.

### Migration Plan

The first step in any migration should be to create a migration plan. This plan will be built on an analysis of the site you're migrating too. This could be a migration from one WordPress site to another, with minimal data changes, or it could be from a completely custom CMS into WordPress. In any case, we need to figure out where the data lives, how it's currently stored, and how that data is going to map into the new site. In almost all cases, this will involve getting the actual data to be migrated (usually a database dump).

Once the data has been analyzed, we can use that information to start writing our migration plan. This plan will contain things like what steps we will be running, how long we expect the migration to take, a mapping of the data from the old site to the new one and any gotchas we are looking out for (expounded upon below). This migration plan will heavily influence the next steps.

### Writing Migration Scripts

Now that we have a solid migration plan in place, which at this point it should have been reviewed by another engineer, gathering feedback and incorporating that back in, we are ready to actually write the scripts that will handle the migration. All migration will vary heavily at this step. Sometimes we can get WXR files and just use the WordPress importer (typically using [WP CLI](http://wp-cli.org/commands/import/)) to handle everything we need. Other times we'll use the WordPress Importer then write a script to modify data once it's in WordPress. And other times we'll write scripts that handle the entire migration process for us.

All these decisions should be part of the migration plan we put together, so at this point, we know exactly what we are going to do and we can start work accordingly. 10up will generally use [WP CLI](http://wp-cli.org/) to power these scripts, which gives us great flexibility on what we can do, what output we can control and typically you'll have a lot less issues with memory limits and timeouts.

### Things To Be Aware Of

The following are some general things to keep in mind when doing these migrations. Note that not all will apply in every scenario and there are probably items missing from this list, but this will give a good general overview of things to keep in mind.

* Test all migration scripts

	This probably goes without saying but migrations should be run multiple times: locally, staging, preprod if available, before it's ever run on production. There will inevitably be issues that need to be fixed, so the more the migration process is tested, the more likely these issues are found and fixed before it's run on production.

	 * In the same vein as this, make sure all scripts are code reviewed before running on stage/preprod/prod.

* Review data

	Once data has been migrated to an accessible server (typically stage), all data should be heavily reviewed to make sure it migrated correctly. This means checking to make sure things like posts have correct titles, correct content, correct authors, correct dates, etc. Normally the client will be helping significantly with this step, as they are the ones most familiar with the content.

* Schedule with host

	When running a migration on a hosted server, make sure the host is aware when these are going to be run. Most migrations take up quite a few resources, so planning this in advance is always a good idea.

* Images (and other media)

	Media, typically images but can be other things, should be thought through when putting together your migration plan. These types of items typically take longer to bring over, as they have to be downloaded to the new site. Having a plan in place to handle this is important.

	Sometimes media can be left alone, meaning, for instance, any image that's linked to can stay as-is and doesn't need to be moved over. But more often we'll want all media brought over. In this case, if the amount of media is limited, this can be done using core WordPress functions. If the amount of media is great though, this can significantly slow down the migration process and sometimes crash it all together. In this scenario, looking into options to offload this processing is usually the way to go (things like using [Gearman](http://gearman.org/) to process multiple media items at once).

* Redirects

	In some cases, the data structure from the old site to the new changes in such a way that new URL's are used. Sometimes this is on purpose, sometimes it's necessary because of some data changes. In any case, these need to be accounted for so we can add proper redirects, so any links to the old content will redirect to the new content.
	
	There are multiple ways to handle redirects, whether these are set on the server level, whether they are set using a [plugin](https://wordpress.org/plugins/safe-redirect-manager/) or sometimes a custom approach is needed. Generally it's good practice to keep track of all needed redirects as the migration runs, so by the time the migration is done, we have a list of all needed redirects. These can then be implemented with our chosen approach.

* Authors

	Need to make sure authors are brought over and assigned correctly. When creating authors, only create them once, so we don't end up with duplicate authors. Once an author has been brought over the first time, check and re-use that author each time we need it in the future. Some platforms have the ability to set multiple authors on a post, so make sure there's a solution figured out for that if needed.

### Potential Side Effects

Even the most carefully planned migration can have issues. The following are some things that might occur if they're not planned for.

* SEO

	When making changes to data structure, there's always a possibility to negatively impact SEO. If proper thought is put into the redirect item, as mentioned above, that should mitigate most of this. But something that should be thought through and if the migration is making drastic structure changes, something that needs to be accounted for.

* Social

	One thing to make sure of when running migrations is to not trigger any social services that might be set up. This includes sending posts to Facebook, Twitter or email. We don't want to spam subscribers with hundreds, if not thousands of items all in a row, as those items are migrated in.

* Time

	Migrations do tend to take a lot of time, from putting together a good migration plan, writing the migration scripts, testing those scripts, fixing issues found and then finally running the migration on production. Always make sure there's enough time estimated for this in a project and enough time set aside to get all this done within the required time frame.

* Backups

	As has been hinted at a few times in this guide, migrations tend to never work right the very first time, and they end up being run over and over, with tweaks in between to get to the end goal. Always keep a backup of the original data, so at any point we can re-run a migration with a fresh data set.
	
	Also, inevitably there will come a time when after a successful production migration has been done, some other piece of data is found that wasn't originally thought of and now needs to be brought over. As long as an original data source was kept (typically a database backup), new migration scripts can be written and run to get the missing content.
