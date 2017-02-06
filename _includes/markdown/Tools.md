The following are the tools we use at 10up. This list will grow and change over time and is not meant to be comprehensive. Generally, we encourage or require these tools to be used in favor of other ones. Rules governing tools to be used and packaged with a client site will be much stricter than those used on internal projects.

<h3 id="local-development">Local Development Environments</h3>

At 10up, we use [Vagrant](https://www.vagrantup.com/) to build and interact with virtual environments that match production as closely as possible. There are many different Vagrant setups and configurations available. The following setups are the only ones we support internally.

[Varying Vagrant Vagrants](https://github.com/Varying-Vagrant-Vagrants/VVV) - Our standard Vagrant setup for client sites and local development. This was originally a 10up project and something with which we have a lot of familiarity.

[VIP Quickstart](https://github.com/Automattic/vip-quickstart) - A Vagrant setup meant to closely match the WordPress.com VIP environment. If you are working on a VIP project, it is good to have this installed to effectively test your website locally. We only recommend this Vagrant setup for VIP projects.

[Variable VVV - a VVV Site Creation Wizard](https://github.com/bradp/vv) - vv makes it extremely easy to create a new WordPress site using Varying Vagrant Vagrants. vv supports site creation with many different options, including multisite, loading images from live site, and an initial database import.

<h3 id="task-runners">Task Runners {% include Util/top %}</h3>

[Grunt](http://gruntjs.com/) - Grunt is a task runner built on Node that lets you automate tasks like Sass preprocessing and JS minification. Grunt is the only task runner we currently use on company and client projects.

<h3 id="package-managers">Package/Dependency Managers</h3>

[NPM](https://www.npmjs.com/) - NPM is 10up's preferred tool for managing JavaScript frontend dependencies and development dependencies. For frontend dependencies, usually everything we need is bundled with WordPress, but sometimes we need something like [MomentJS](http://momentjs.com/) or [Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) polyfill support for all browsers. NPM helps us fill in the gaps and is a great tool for adding these dependencies to our frontend development. NPM also allows us to manage dependencies for our development - to speed up our engineering, enhance our understanding of our code, or allow for better error reporting during development. Dependencies should always be installed alongside a project whenever it gets used (ex. a WordPress plugin, a NPM module, or custom library). Development dependencies are installed when you’re actively working (developing) on the project and not using it as a 3rd party library. When managing dependencies for both frontend and development it's important to separate these [dependencies](https://docs.npmjs.com/files/package.json#dependencies) necessary for production and the development dependencies ([devDependencies](https://docs.npmjs.com/files/package.json#devdependencies)). 10up follows strict development practices for dependency management and encourages developers to review the NPM docs to thoroughly understand these concepts.

[Composer](https://getcomposer.org) - We use Composer for managing PHP dependencies. Usually everything we need is bundled with WordPress. Sometimes we need external libraries like "Patchwork". Composer is a great way to manage those external libraries but is not necessary on most projects

<h3 id="version-control">Version Control {% include Util/top %}</h3>

[Git](http://git-scm.com) - At 10up we use Git for version control. We encourage people to use the command line for interacting with Git. GUI’s are permitted but will not be supported internally.

[SVN](https://subversion.apache.org/) - We use SVN, but only in the context of WordPress.com VIP. Again, we encourage people to use the command line as we do not support GUI's internally.

<h3 id="deployments">Deployments {% include Util/top %}</h3>
The best deployment is quick and requires no site down time: At 10up we’ve spent a lot of our efforts to refine this process and make sure our deployments are secure and speedy. Our 3 primary deployment processes are outlined below
* Atomic
* Webhooks
* SFTP uploads
All of these deployment tools are utilizing a third party VCS repository - Beanstalk, Github, Gitlab, etc... .

10up's recommended deployment cycle is get really outlined below

* Create new feature in feature branch
* (Do not include compiled files, dependency files, or vendor directories!)
* Have branch approved/ reviewed by a peer
* Merge feature branch into master/deploy branch and push to the remote repository
At this point the deployment environment takes over
* Repository receives new code and prepares deployment
* Any pre-deployment commands are run
	* Install any new dependencies for production (Note: devDependencies should not be installed)
	* Run any build commands that produce necessary compiled files
* Push all code to production environment excluding vendors directories and dependency files
	* Note: These files will (or should) be represented in your compiled file

While 10up doesn't recommend one solution or company over another, we do recommend using the best tools and solutions for the job, and that can vary between projects.

For security of your deployment, it's imperative to follow the above recommendations for dependency management. When using an SFTP solution, don't use the root user. It's better to create a custom ftp user with clear access. You shouldn't share this access with other users. Finally, only give deployment access to those who need it. Not every developer on a team will need access to deployments or the ability to modify those deployments. It's better to limit users to only have the access they absolutely need.

When deploying code and using the WordPress enqueue system, it's imperative to only have relevant code on the page. Sometimes there is a special page that uses an extra library and instead of requiring this on every page, it's better to rely on WordPress to enqueue this file for you. Instead of compiling all your dependencies needed by any feature on your site into one file, it's better to compile a few core libraries or tools for use on every page and only enqueue what you need on a page. This will reduce page load, simplify architecture by making it clear where dependencies get used, and avoid conflict with other plugins or themes on your site.

<h3 id="command-line">Command Line Tools</h3>

[WP-CLI](http://wp-cli.org) - A command line interface for WordPress. This is an extremely powerful tool that allows us to do imports, exports, run custom scripts, and more via the command line. Often this is the only way we can affect a large database (WordPress.com VIP or WPEngine). This tool is installed by default on VVV and VIP Quickstart.
