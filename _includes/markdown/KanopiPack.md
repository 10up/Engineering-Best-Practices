## Migrating a WordPress site to Kanopi Pack

There are many steps involved in converting a legacy site, or creating a new site, using (Kanopi Pack)[https://github.com/kanopi/kanopi-pack/]. Below, they are detailed in the steps recommended. This is meant to be a high level overview with explanations. Considerations may be needed on a project-to-project basis.

1. Composer
2. Docksal
3. WP Config
4. MU Plugins
5. Theme

CircleCI and Tugboat changes are not referenced here, as that should be handled by the TechOps team. However, any compiled changes should NOT be stored in the repo, and instead, handled via CI.

## Composer

* In your project root, you will need to have a `composer.json` file. This is separate from your WordPress theme files.
* You should ensure that the name is unique to your project. It's highly suggested that you match this to the GitHub repo name (in this case, `ftd-fpi`).
* The example `composer.json` file below is for a Pantheon-based, fully composer build.
* Remove the `johnpbloch/wordpress-core` package if you do not manage core via Composer. However, the rest is required for use of the Kanopi Pack Asset Loader, and the updated PHPCS standards.
* If you do manage core via Composer, to add contributed plugins, run `composer require wpackagist-plugin/[plugin name]`. You can search for these on WPackagist, or simply by taking the slug from the official Plugin repo, and using that for the plugin name.
* Please update the version of PHP, WordPress Core and Kanopi Pack based on the latest supported version available. For Kanopi Pack, head over to (the repo)[https://github.com/kanopi/kanopi-pack] for the latest release number.
* **NOTE**: If your project is a Pantheon-hosted site, please make sure your WP files are in a `/web/` subfolder. This is not needed, nor encouraged, for other sites. Remove that reference from the sample below.

```
{
    "name": "kanopi/name-of-repo",
    "description": "",
    "type": "project",
    "keywords": [],
    "repositories": {
        "wpackagist": {
            "type": "composer",
            "url": "https://wpackagist.org"
        }
    },
    "require": {
        "php": ">=8.2",
        "composer/installers": "2.x-dev",
        "johnpbloch/wordpress-core": "6.3",
        "kanopi/pack-asset-loader": "~1.0.2"
    },
    "require-dev": {
        "automattic/vipwpcs": "^2.3",
        "phpunit/phpunit": "^9.5.3",
        "roave/security-advisories": "dev-master",
        "squizlabs/php_codesniffer": "^3.4.0"
    },
    "config": {
        "vendor-dir": "web/wp-content/mu-plugins/vendor",
        "preferred-install": "dist",
        "optimize-autoloader": true,
        "sort-packages": true,
        "platform": {
            "php": "8.2"
        },
        "allow-plugins": {
            "composer/installers": true,
            "cweagans/composer-patches": true,
            "dealerdirect/phpcodesniffer-composer-installer": true,
            "oomphinc/composer-installers-extender": true
        }
	},
    "scripts": {
        "move-core-files": "rsync -az --delete --exclude 'wp-content' web/wp-content/mu-plugins/vendor/johnpbloch/wordpress-core/* web/; echo 'Moved core files to web directory' ",
        "post-install-cmd": [
            "@move-core-files"
        ],
        "post-update-cmd": [
            "@move-core-files"
        ],
        "code-sniff": [
            "Composer\\Config::disableProcessTimeout",
            "web/wp-content/mu-plugins/vendor/bin/phpcs --ignore=*/node_modules/*,,*/patterns/* --standard=WordPress-Extra --extensions=php web/wp-content/themes/custom/"
        ],
        "code-fix": "web/wp-content/mu-plugins/vendor/bin/phpcbf --ignore=*/node_modules/*,,*/patterns/* --standard=WordPress-Extra --extensions=php web/wp-content/themes/custom/"
    },
    "extra": {
        "installer-paths": {
            "web/wp-content/plugins/{$name}/": [
                "type:wordpress-plugin"
            ],
            "web/wp-content/themes/{$name}/": [
                "type:wordpress-theme"
            ],
            "web/wp-content/themes/custom/{$name}/": [
                "type:wordpress-theme-custom"
            ]
        }
    }
}
```

## Docksal

### .env

Below is a Pantheon-specific example for your `docksal.env` file. For WPEngine sites, change the stack to `default`, and the DOCROOT to `.`

*We do not have an image available for PHP 8.2 at the moment for Docksal. Please update the image when one becomes available.*

```
DOCKSAL_STACK=pantheon
CLI_IMAGE='docksal/cli:php8.0-3'

# Docksal configuration.
DOCROOT=web

# Enable/disable xdebug
# To override locally, copy the two lines below into .docksal/docksal-local.env and adjust as necessary
XDEBUG_ENABLED=0

# WordPress settings
WP_ADMIN_USER=example
WP_ADMIN_PASS=example
WP_ADMIN_EMAIL=example_email_address

# If you'd like the installer to set up your theme, uncomment this line and add your theme folder.
WP_THEME_SLUG=custom/ucsf
WP_THEME_ASSETS_HOST_SUBDOMAIN=theme-assets
WP_THEME_RELATIVE_PATH=wp-content/themes/$WP_THEME_SLUG

# Local ssl certs folder
CONFIG_CERTS="${CONFIG_CERTS:-$HOME/.docksal/certs}"

# Set hosting details for Pull command (Pantheon specific)
# Put any specific variables for your refresh command here.

```

### .yml

```
version: "2.1"

services:
  web:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: nginx
    environment:
      - APACHE_FILE_PROXY
      - WP_THEME_ASSETS_HOST_SUBDOMAIN
      - WP_THEME_RELATIVE_PATH
      - WP_THEME_SLUG
      - NGINX_VHOST_PRESET=wordpress
  cli:
    environment:
      - WP_ADMIN_USER
      - WP_ADMIN_PASS
      - WP_ADMIN_EMAIL
      - WP_THEME_RELATIVE_PATH
      - WP_THEME_ASSETS_HOST_SUBDOMAIN
      - WP_THEME_SLUG
      - COMPOSER_MEMORY_LIMIT=-1
      - VIRTUAL_HOST
      - CONFIG_CERTS
      - DB_HOST=db
      - DB_NAME=default
      - DB_USER=user
      - DB_PASSWORD=user
    labels:
      - io.docksal.virtual-host=${WP_THEME_ASSETS_HOST_SUBDOMAIN}.${VIRTUAL_HOST}
      - io.docksal.virtual-port=4400
    expose:
      - 4400
  pma:
    hostname: pma
    image: phpmyadmin/phpmyadmin
    environment:
      - PMA_HOST=db
      - PMA_USER=root
      - PMA_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}
    labels:
      - io.docksal.virtual-host=pma.${VIRTUAL_HOST}
```

### Commands

You will need to create or update the following commands:
* fin init
* fin development
* fin production
* fin init-theme-assets
* fin npm

Please copy these from (this Cacher)[https://snippets.cacher.io/snippet/c0ba9321b584bfa1c756].

## WP Config

For Kanopi Pack to be able to run its development server, you will need to add the following code to your `wp-config-local.php`:

```
/**
 * For Front-end Development Server to be served via @kanopi/pack
 */
define('KANOPI_DEVELOPMENT_ASSET_URL', 'https://' . getenv('WP_THEME_ASSETS_HOST_SUBDOMAIN') . '.' . getenv('VIRTUAL_HOST'));
```

## MU-Plugins

Within the `mu-plugins` folder, situated under `wp-content`, you will need the following code added. Filename suggestion is `001-kanopi-app-loader.php`. This is required for the Asset Loader to work. Please make sure to exclude it from the `.gitignore`.

```
<?php
/**
 * Plugin Name: Kanopi MU Plugin Application Loader
 * Author: Kanopi, Inc.
 * Author URI: https://kanopi.com
 * Description: Kanopi Autoloader initializes Composer based Autoloader along with required plugins
 *
 * @wordpress-plugin
 * Version: 1.0.0
 */

// Run the autoloader for the site if not loaded externally
if ( ! class_exists( 'Kanopi\Assets\Registry\WordPress' ) ) {
	if ( ! file_exists( WP_CONTENT_DIR . '/mu-plugins/vendor/autoload.php' ) ) {
		wp_die( 'Unable to run theme autoloader.' );
	}

	include_once WP_CONTENT_DIR . '/mu-plugins/vendor/autoload.php';
}
```

## Theme

### NPM Packages

* In the theme, add a `.nvmrc` file, with the contents being 20.5. This will force NPM/NVM to use Node 20, as older versions have, or are hitting EOL (end of life).
* You will need to modify (or create) a `package.json` file. If you have an existing one, remove your `package-lock.json`, and any `node_modules` you may have (if you have spun up already). 
	* To install new packages, run `fin npm i [packagename]`. You may install multiple packages at once, by separating out the package name with a space. If this is a dev dependency, add the `--save-dev` flag.
	* To remove packages, either remove the line in `package.json`, or run `fin npm uninstall [packagename]`
* You will need to make sure `@kanopi/pack` is installed, and if you are using React, `@kanopi/pack-react`. 
	* The scripts section will differ from regular Kanopi Pack (KP), and the React version. Both will be development/production, but change slightly. The example package.json below uses regular KP, but the React version is `"production": "kanopi-pack-react react",` and `"development": "kanopi-pack-react react development"`.

```
{
  "name": "your-theme",
  "version": "1.0.0",
  "repository": {
    "type": "wordpress-theme-custom",
    "url": "https://github.com/kanopi/wp-basebuild"
  },
  "private": true,
  "scripts": {
    "production": "kanopi-pack standard",
    "development": "kanopi-pack standard development"
  },
  "devDependencies": {
    "@kanopi/pack": "^2.2.0",
    "sass-toolkit": "^2.10.2"
  },
  "engines": {
    "node": ">=20",
    "npm": ">=9"
  }
}
```  	

### Assets

You will need to have an `/assets/` folder, with the following two subfolders, `/config/`, and `/src/`. All your JS and SASS/SCSS partials will live in the `/src/` folder, with the folder structure being explained below. Your images and fonts will live in the `/static/` folder under `/src/`.

```
├── src
│   ├── js
│   │   ├── **/*/*.js
│   │   ├── theme.js
│   ├── scss
│   │   ├── **/*/*.scss
│   │   ├── theme.scss
│   ├── static
│   │   ├── images
│   │       ├── */[fileextension]

```

#### Config

You will need to create a `kanopi-pack.js` file, along with a subfolder called `/tools/`, which will contain your StyleLint exclusions. Below is an example of a `kanopi-pack.js` configuration file. You may find the full explanation at the [Kanopi Pack repo](https://github.com/kanopi/kanopi-pack/blob/main/documentation/configuration.md).

The entry points below correspond to your main files. For instance, if your theme styles live in `theme.scss`, you would create an entry point called `theme`, and then reference the path. The same would go for your Javascript. In the example below, the `legacy` entry point contains miscellanous Javascript from legacy builds, and have been included in that subfolder. The `customizer` endpoint is for any Customizer or admin-related scripts.

At the bare minimum, you must provide an entry point for your theme. The naming is important, as that will be referenced later in `functions.php`. 


```
const {
	VIRTUAL_HOST: sockHostDomain = "",
    WP_THEME_ASSETS_HOST_SUBDOMAIN: sockHostSubdomain = ""
} = process.env;

module.exports = {
	"devServer": {
		"sockHost": sockHostSubdomain + '.' + sockHostDomain,
		"sockPort": 443,
		"useSslProxy": true,
		"useProxy": true,
		"watchOptions": {
			"poll": true
		},
		"allowedHosts": [".docksal.site"]
	},
	"environment": {
		"dotenvEnable": false
	},
	"filePatterns": {
		"cssOutputPath": "css/[name].[contenthash].css",
		"entryPoints": {
			"legacy": "./assets/src/js/legacy.js",
			"theme": "./assets/src/scss/theme.scss",
			"customizer": "./assets/src/js/customizer.js"
		},
		"jsOutputPath": "js/[name].[contenthash].js"
	},
	"styles": {
		"scssIncludes": [
			"./assets/src/scss/shared/utilities.scss" 
		],
		"styleLintConfigFile": "./assets/configuration/tools/.stylelintrc.json", 
		"styleLintIgnorePath": "./assets/configuration/tools/.stylelintignore"
        "devHeadSelectorInsertBefore": "#id-of-enqueued-style"
	},
	"scripts": {
		"esLintAutoFix": false,
		"esLintDisable": true,
	}
};
```

* The devHeadSelectorInsertBefore lets you define where to place the development server CSS while you work on the site locally. It is very useful when you work in sites that use plugins like BuddyBoss. If you do not need it, you can remove that line. Passing a wrong ID will hide your compiled CSS.
* The `scssIncludes` will contain all utilities, such as variables and mixins, that are needed for your stylesheet to compile correctly. 

#### Stylelint

If you are using a pre-purchased theme, or are converting a legacy project that may not have followed best CSS practices, you will want to employ the use of a StyleLint config file. Below is an example of the `.stylelintignore` file. You can see below how to add new rules as necessary. 

The above example references Stylelint being placed in a subfolder of tools. It is highly suggested that you migrate your stylelint to there. However, by changing the path to your project/theme root, you should be able to reference it's existing location. 

```
{
	"rules": {
		"order/properties-order": null,
		"color-hex-length": null,
		"string-quotes": null,
		"rule-empty-line-before": null,
		"color-named": null,
		"declaration-property-value-disallowed-list": null
	},
	"customSyntax": "postcss-scss",
	"extends": "stylelint-config-property-sort-order-smacss"
}
```

You may also disable particular rules inline (as the above is global), using `/* stylelint-disable [RULENAME} */`, and then re-enabling with `/* stylelint-enable [RULENAME] */`

### Functions

Now that you've moved all your assets and have a good understanding of what compiled files will be required, it's time to update the way WordPress will enqueue the files.

Start by adding these libraries to the root of your `functions.php`:

```
// Enqueue things.
use Kanopi\Assets\Model\LoaderConfiguration;
use Kanopi\Assets\Registry\WordPress;
```

Right after, add the function found below. A few things to know/update:

#### Loader Configuration

1. `PRODUCTION_URL` should be replaced with the production link of the project's website.

#### Frontend Scripts

1. The `vendor` script might show an error on your production environment.
2. The `runtime` script needs to stay and you do not have to setup anything for it.
3. The `theme` style is the name of the `scss` file provided on `kanopi-pack.js` as an entry point. Any file generated by the compiler must be called this way.
4. There is an example of how to use an `action` hook to load a specific file. In this case, we are loading styles for the Classic Editor.
5. The legacy `wp_register_style` only needs the `SITENAME` value updated.
6. Below, you have an example of a standard external file being enqueued, if you need it.

#### Block Scripts

1. If your site is using blocks, this is how you would register the custom styles and scripts.

```
/**
 * Kanopi Pack Theme Setup
 *
 * @return void
 */
if ( class_exists( 'Kanopi\Assets\Registry\WordPress' ) ) {
	// All assets are held in the active theme under the directory /assets.
	// The constant `KANOPI_DEVELOPMENT_ASSET_URL` is defined before calling, otherwise only Production mode is available.
	$loader = new WordPress(
		new LoaderConfiguration(
			WordPress::read_theme_version(),
			array( 'PRODUCTION_URL' ),
			'/assets/dist/webpack-assets.json'
		)
	);

	$loader->register_frontend_scripts(
		function ( $_registry ) {
			$loader = $_registry->asset_loader();

			$loader->register_vendor_script( 'vendor' );

			$loader->register_runtime_script( 'runtime', array( 'jquery' ) );

			$loader->register_style( 'theme' );

			$loader->register_script( 'legacy' );

			add_action( 'admin_init', function () use ( $loader ) {

				$loader->register_style( 'editor' );

			});

			// Required theme stylesheet.
			wp_register_style(
				'SITENAME-style-header',
				esc_url_raw( get_stylesheet_directory_uri() . '/style.css' ),
				array(),
				$_registry::read_theme_version(),
			);
			wp_enqueue_style( 'SITENAME-style-header' );

			wp_register_script( 'fontawesome', '//kit.fontawesome.com/6b142e11da.js', array( 'jquery' ) );
			wp_enqueue_script( 'fontawesome' );

			// Enqueue our assets last.
			$loader->enqueue_assets();
		}
	);

  $loader->register_block_editor_scripts(
		function ( $_registry ) {
			$loader = $_registry->asset_loader();
			$loader->register_vendor_script( 'vendor' );

			$loader->register_runtime_script( 'runtime', array( 'jquery' ) );
			$loader->register_style( 'editor' );

			$loader->enqueue_assets();
		}
	);
} //end if
```

## You made it!

Once you have completed the installation, you can run `fin development` and confirm that your assets are being compiled.

Head over to your Docksal site and enjoy coding in a much faster way!

## Troubleshooting

Below are some common issues that have been encountered.

**_My styles aren't loading!_**

Make sure that you are running `fin development`. If this is running, and your styles still aren't loading, make sure you have the Kanopi Pack Asset loader installed, and loading (see MU Plugins above). You cannot run `fin open` before `fin development`.

**_CircleCI says the build step was successful, but my site is borked_**

This likely means there was a silent fail on `production`. To test this, run `fin production`, and see if your distribution folder is generated in `assets`. If it is not, run `fin development` to diagnose the issue. Often, especially with React apps, it could be something as simple as case sensitivity.

**_fin development won't run for me :(_**

Sometimes Docker can be an resource hog. Stop all your running projects, and restart (`fin restart`) just the one you are working on, and try `fin development` again. If that doesn't work, restart Docker Desktop.

**_fin production isn't working on CircleCI_**

You may run `fin production` in your local environment in the future to debug a deployment that is failing. Make sure to add a `.gitignore` file in your theme to avoid pushing files from the `dist` folder.