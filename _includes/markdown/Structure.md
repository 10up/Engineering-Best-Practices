<h3 id="integrations">Third-Party Integrations</h3>

Any and all third-party integrations need to be documented in an `INTEGRATIONS.md` file at the root of the project repository. This file includes a list of third-party services, which components of the project those services power, how the project interacts with the remote APIs, and when the interaction is triggered.

For example:

```
## CrunchBase
Remote service for fetching funding and other investment data related to tech startups.

### Scheduling
- The CrunchBase API is used via JS in a dynamic product/company search on post edit pages
- Funding data is pulled every 6 hours by WP Cron to update cached data

### Integration Points
- /assets/js/src/crunchbase-autocomplete.js
- /includes/classes/crunchbase.php
- /includes/classes/cron.php

### Development API
- See http://somesitethatrequireslogin.com/credentials-for-project
```

#### API Keys and Credentials

Authentication credentials and API keys should _never_ be hard-coded into a project. Hard-coding production credentials leads to embarrassing eventualities like posting development content to Twitter or emailing such content to clients' mail lists.

Where possible, the project should expose a UI for entering and managing third party credentials.

If a management UI is impossible due to the nature of the project, credentials should be loaded via either PHP constants or WordPress filters. These options can - and should - default to developer credentials in the absence of production data.
 
```php
<?php
// Production API keys should ideally be defined in wp-config.php
// This section should default to a development or noop key instead.
if ( ! defined( 'CLIENT_MANDRILL_API_KEY' ) && ! ENV_DEVELOPMENT ) {
	define( 'CLIENT_MANDRILL_API_KEY', '1234567890' );
}
```

The `ENV_DEVELOPMENT` constant should always be set to `true` for local development and should be used whenever and wherever possible to prevent production-only functionality from triggering in a local environment.

The location where other engineers can retrieve developer API keys (i.e. Basecamp thread) can and should be logged in the `INTEGRATIONS.md` file to aid in local testing. Production API keys must _never_ be stored in the repository, neither in text files or hard-coded into the project itself.

<h3 id="modular-code">Modular Code</h3>

Every project, whether a plugin a theme or a standalone library, should be coded to be reusable and modular.

#### Plugins

If the code for a project is split off into a functionality plugin, it should be done in such a way that the theme can function when the functionality plugin is disabled, broken, or missing. Each plugin should operate within its own namespace, both in terms of code isolation and in terms of internationalization.

Any functions the plugin exposes for use in a theme should be done so through actions and filters - the plugin should contain multiple calls to `add_filter()` and `add_action()` as the hooks themselves will be defined in the theme.

#### Themes

 Any theme dependencies on functionality plugins should be built with the use of `do_action()` or `apply_filters()`.

**In short,** changing to the default theme should not trigger errors on a site. Nor should disabling a functionality plugin - every piece of code should be decoupled and use standard WordPress paradigms (hooks) for interacting with one another.

#### General Notes

Every project, whether it includes Composer-managed dependencies or not, _must_ contain a `composer.json` file defining the project so it can in turn be pulled in to _other_ projects via Composer.  For example:

```json
{
	"name": "10up/{project name}",
	"type": "wordpress-plugin",
	"minimum-stability": "dev",
	"require-dev": {},
	"require": {},
	"version": "1.0.1",
	"dist": {
		"url": "... stable archive package URI ...",
		"type": "zip"
	}
}
```

When code is being reused between projects, it should be abstracted into a standalone library that those projects can pull in through Composer. Generally, code is client- or project-specific, but if it's abstract enough to be reused we want to capture that and maintain the code in one place rather than copy-pasting it between repositories.

<h3 id="dependencies">Dependencies {% include Util/top %}</h3>

Projects generally use three different classes of dependency management:

- [npm](http://npmjs.org) is used to manage build dependencies like Grunt and its related plugins
- [Composer](http://getcomposer.org) is used primarily for back-end (i.e. admin or PHP-based) dependencies
- [Bower](http://bower.io) is used to manage front-end (i.e. script and style framework) dependencies

Generally, dependencies pulled in via a manager are _not_ committed to the repository, just the `.json` file defining the dependencies. This allows all developers involved to pull down local copies of each library as needed, and keeps the repository fairly clean.

With some projects, using an automated dependency manager won't make sense. In server environments like VIP, running dependency software on the server is impossible. If required repositories are private (i.e. invisible to the clients' in-house developers), expecting the entire team to use a dependency manager is unreasonable. In these cases, the dependency, its version, and the reason for its inclusion in the project outside of a dependency manager should be documented.

<h3 id="file-organization">File Organization {% include Util/top %}</h3>

Project structure unity across projects improves engineering efficiency and maintainability. We believe the following structure is segmented enough to keep projects organized—and thus maintainable—but also flexible and open ended enough to enable engineers to comfortably modify as necessary. All projects should derive from this structure:

```
|- bin/ __________________________________ # WP-CLI and other scripts
|- node_modules/ _________________________ # npm/Grunt modules
|- bower_components/ _____________________ # Frontend dependencies
|- vendor/ _______________________________ # Composer dependencies
|- assets/
|  |- images/ ____________________________ # Theme images
|  |- fonts/ _____________________________ # Custom/hosted fonts
|  |- js/
|    |- src/ _____________________________ # Source JavaScript
|    |- project.js _______________________ # Concatenated JavaScript
|    |- project.min.js ___________________ # Minified JavaScript
|  |- css/
|    |- scss/ ____________________________ # See below for details
|    |- project.css
|    |- project.min.css
|    |- project-admin.css
|    |- project-admin.min.css
|    |- editor-style.css
|- includes/ _____________________________ # PHP classes and files
|- templates/ ____________________________ # Page templates
|- partials/ _____________________________ # Template parts
|- languages/ ____________________________ # Translations
|- tests/
|  |- php/ _______________________________ # PHP testing suite
|  |- js/ ________________________________ # JavaScript testing suite
```

The `scss` folder is described seperately, below to improve readability:

```
|- assets/css/scss/
|  |- global/ ____________________________ # Functions, mixins, placeholders, and variables
|  |- base/
|    |- reset, normalize, or sanitize
|    |- typography
|    |- icons
|    |- wordpress ________________________ # Partial for WordPress default classes
|  |- components/
|    |- buttons
|    |- callouts
|    |- toggles
|    |- all other modular reusable UI components
|  |- layout/
|    |- header
|    |- footer
|    |- sidebar
|  |- templates/
|    |- home page
|    |- single
|    |- archives
|    |- blog
|    |- all page, post, and custom post type specific styles
|  |- admin/ _____________________________ # Admin specific partials
|  |- editor/ ____________________________ # Editor specific partials (leverage placeholders to use in front-end and admin area)
|  |- admin.scss
|  |- project.scss
|  |- editor-styles.scss
```