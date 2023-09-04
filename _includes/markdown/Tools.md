The following are tools we use at 10up. This list is not comprehensive and will grow and change over time. Generally, we encourage engineers to use these tools in favor of others. Rules governing tools to be used and packaged with a client site will be much stricter than those used on internal projects.

<h2 id="local-development" class="anchor-heading">Local Development Environments {% include Util/link_anchor anchor="local-development" %} {% include Util/top %}</h2>

At 10up, we use [Local WP](https://localwp.com/) to build and interact with local environments. Local WP makes it easy to spin up, manage, and interact with local WordPress environments. It's available for Mac, Windows, and Linux.

Local WP replaces Docker and WP Local Docker as the recommended development environment at 10up.

<h2 id="scaffolding" class="anchor-heading">Scaffolding {% include Util/link_anchor anchor="scaffolding" %} {% include Util/top %}</h2>

[10up WP Scaffold](https://github.com/10up/wp-scaffold) - Developers can use 10up Project Scaffold to quickly create themes and plugins with our recommended tools and many of our best practices already in place.

<h2 id="task-runners" class="anchor-heading">Task Runners {% include Util/link_anchor anchor="task-runners" %} {% include Util/top %}</h2>

[10up-toolkit](https://github.com/10up/10up-toolkit/blob/develop/packages/toolkit/README.md) - 10up Toolkit is 10up’s official asset bundling tool based on Webpack 5. It comes with support for most everyday requirements within 10up projects.

[Webpack](https://webpack.github.io/) - Webpack is a bundler for JS/CSS. It’s beneficial when 10up Toolkit can’t handle a project’s requirements.

<h2 id="package-managers" class="anchor-heading">Package/Dependency Managers {% include Util/link_anchor anchor="package-managers" %} {% include Util/top %}</h2>

[Composer](https://getcomposer.org) - We use Composer for managing PHP dependencies. When we need to pull in external PHP libraries, Composer provides an easy way to install and update those.

The [WordPress Packagist](https://wpackagist.org/) repository mirrors all public WordPress plugins and themes, allowing an engineering team to easily manage them using Composer.

<h2 id="version-control" class="anchor-heading">Version Control {% include Util/link_anchor anchor="version-control" %} {% include Util/top %}</h2>

[Git](https://git-scm.com) - At 10up we use Git for version control. We encourage people to use the command line for interacting with Git. GUIs are permitted but will not be supported internally.

<h2 id="command-line" class="anchor-heading">Command Line Tools {% include Util/link_anchor anchor="command-line" %} {% include Util/top %}</h2>

[WP-CLI](https://wp-cli.org) - A command line interface for WordPress. This extremely powerful tool allows us to do imports, exports, run custom scripts, and more via the command line. Often, this is the only way we can affect a large database (WordPress.com VIP or WP Engine). This tool comes bundled with [Local WP](https://localwp.com/).

<h2 id="a11y-testing" class="anchor-heading">Accessibility Testing {% include Util/link_anchor anchor="a11y-testing" %} {% include Util/top %}</h2>

We use a variety of tools to test our sites for accessibility issues. WebAim has some great resources on [how to evaluate sites](http://webaim.org/articles/screenreader_testing/) with a screen reader.

* [Using VoiceOver](http://webaim.org/articles/voiceover/)
* [Using NVDA](http://webaim.org/articles/nvda/)
* [Using JAWS](http://webaim.org/articles/jaws/)

We're also a fan of a few browser tools that lend us a hand when it comes to testing areas like color contrast, heading hierarchy, and ARIA application.

* [Headings Map for Chrome](https://chrome.google.com/webstore/detail/headingsmap/flbjommegcjonpdmenkdiocclhjacmbi?hl=es) or [Headings Map for Firefox](https://addons.mozilla.org/en-us/firefox/addon/headingsmap/) - A browser extension that allows you to see the heading structure of a webpage.
* [The Visual ARIA Bookmarklet](http://whatsock.com/training/matrices/visual-aria.htm) - A bookmarklet that can be run on a webpage and color codes ARIA roles.
* [WAVE](http://wave.webaim.org/) - A toolkit from WebAIM, that also has an extension for Chrome/Firefox. It evaluates a webpage and returns accessibility errors.
* [Accessibility Developer Tools](https://chrome.google.com/webstore/detail/accessibility-developer-t/fpkknkljclfencbdbgkenhalefipecmb) - A Chrome extension that adds an "Audit" tab in Chrome's developer tools that can scan a webpage for accessibility issues.
* [Tota11y](https://khan.github.io/tota11y/) - A visualization toolkit that can be used as a bookmarklet, and reveals accessibility errors on a webpage.
* [Contrast Ratio](https://leaverou.github.io/contrast-ratio/) - A color contrast tool to compare two colors against [levels of conformance](https://www.w3.org/TR/UNDERSTANDING-WCAG20/conformance.html) and see if they pass.
* [Tanagaru Contrast Finder](http://contrast-finder.tanaguru.com/?lang=en) - Another color contrast tool that tests colors against the levels of conformance, but also provides you with alternatives should your provided colors fail.

<h2 id="vrt" class="anchor-heading">Visual Regression Testing {% include Util/link_anchor anchor="vrt" %} {% include Util/top %}</h2>

We use visual regression testing to ensure code changes don't have unforeseen repercussions. This provides a helpful visual aid to check against CSS changes, plugin updates, and third-party script updates.

* [BackstopJS](https://github.com/garris/BackstopJS) - A tool used to run visual regression tests that compares known reference states against updates.
