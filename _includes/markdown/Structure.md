### Templates

10up has developed two project templates for use with setting up new theme and plugin projects:

1. [grunt-wp-theme](https://github.com/10up/grunt-wp-theme)
1. [grunt-wp-plugin](https://github.com/10up/grunt-wp-plugin)

In addition, 10up is always working to iterate on these templates and is working on a unified [Yeoman](http://yeoman.io) generator for WordPress projects. When possible, one of these official templates should be used to bootstrap projects as they set a unified directory structure for projects.

Concretely, all new projects should include:

- A `.gitignore` file ignoring common directories like `.sass-cache`, `node_modules`, and `.idea`
- A `.jshintrc` file defining JSHint standards
- An `.editorconfig` file defining line-ending standards and common editor configurations
- A Gruntfile defining the build process
- A `package.json` defining the project and it's npm <a href="#dependencies">dependencies</a>
- A [`composer.json`](#modular-code) defining the project at a minimum (so it can be included via Composer in other projects) and optionally any back-end dependencies
- A `bower.json` (optional) defining the project's script dependencies

Styles should be placed in an `/assets/css` directory - raw files in either a `/src` or a `/sass` subdirectory, depending on the use of preprocessors and processed files in the root of the CSS directory.

Scripts should be placed in an `/assets/js` directory - raw files in a `/src` subdirectory and concatenated/minified files in the root of the directory (ideally, minification will happen on the server and dynamically-generated files will be ignored by the repository).

Vendor scripts and style should be placed in their respective `/vendor` directories and ignored by linting tools.

### Modular Code

Every project, whether a plugin a theme or a standalone library, should be coded to be reusable and modular. Plugins should be entirely self-contained and expose access to their internals through actions and filters. Themes should likewise use actions and filters for extensibility.

**In short,** changing to the default theme should not trigger errors on a site. Nor should disabling a functionality plugin - every piece of code should be decoupled and use standard WordPress paradigms (hooks) for interacting with one another.

Every project, whether it includes back-end dependencies or not, _must_ contain a `composer.json` file defining the project so it can in turn be pulled in to _other_ projects via Composer.  For example:

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

### Dependencies

Projects generally use three different classes of dependency management:

- [npm](http://npmjs.org) is used to manage build dependencies like Grunt and its related plugins
- [Composer](http://getcomposer.org) is used primarily for back-end (i.e. admin or PHP-based) dependencies
- [Bower](http://bower.io) is used to manage front-end (i.e. script and style framework) dependencies

Generally, dependencies pulled in via a manager are _not_ committed to the repository, just the `.json` file defining the dependencies. This allows all developers involved to pull down local copies of each library as needed, and keeps the repository fairly clean.

With some projects, using an automated dependency manager won't make sense. In server environments like VIP, running dependency software on the server is impossible. If required repositories are private (i.e. invisible to the clients' in-house developers), expecting the entire team to use a dependency manager is unreasonable. In these cases, the dependency, its version, and the reason for its inclusion in the project outside of a dependency manager.