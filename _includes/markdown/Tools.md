The following are the tools we use at 10up. This list will grow and change over time and is not meant to be comprehensive. Generally, we encourage or require these tools to be used in favor of other ones. Rules governing tools to be used and packaged with a client site will be much stricter than those used on internal projects.

<h3 id="local-development">Local Development Environments</h3>

At 10up, we use [Vagrant](https://www.vagrantup.com/) to build and interact with virtual environments that match production as closely as possible. There are many different Vagrant setups and configurations available. The following setups are the only ones we support internally.

[Varying Vagrant Vagrants](https://github.com/Varying-Vagrant-Vagrants/VVV) - Our standard Vagrant setup for client sites and local development. This was originally a 10up project and something with which we have a lot of familiarity.

[VIP Quickstart](https://github.com/Automattic/vip-quickstart) - A Vagrant setup meant to closely match the WordPress.com VIP environment. If you are working on a VIP project, it is good to have this installed to effectively test your website locally. We only recommend this Vagrant setup for VIP projects.

<h3 id="task-runners">Task Runners {% include Util/top %}</h3>

[Grunt](http://gruntjs.com/) - Grunt is a task runner built on Node that lets you automate tasks like Sass preprocessing and JS minification. Grunt is the only taskrunner we currently use on company and client projects.

<h3 id="package-managers">Package/Dependency Managers</h3>

[Bower](http://bower.io/) - A good tool to manage front end packages. Usually everything we need is bundled with WordPress. Sometimes we need something like "Chosen.js" that isn’t included. Bower is a good way to manage external libraries like that but is not necessary on most projects.

[Composer](https://getcomposer.org) - We use Composer for managing PHP dependencies. Usually everything we need is bundled with WordPress. Sometimes we need external libraries like "Patchwork". Composer is a great way to manage those external libraries but is not necessary on most projects

<h3 id="version-control">Version Control {% include Util/top %}</h3>

[Git](http://git-scm.com) - At 10up we use Git for version control. We encourage people to use the command line for interacting with Git. GUI’s are permitted but will not be supported internally.

[SVN](https://subversion.apache.org/) - We use SVN, but only in the context of WordPress.com VIP. Again, we encourage people to use the command line as we do not support GUI's internally.

<h3 id="command-line">Command Line Tools</h3>

[WP-CLI](http://wp-cli.org) - A command line interface for WordPress. This is an extremely powerful tool that allows us to do imports, exports, run custom scripts, and more via the command line. Often this is the only way we can affect a large database (WordPress.com VIP or WPEngine). This tool is installed by default on VVV and VIP Quickstart.


