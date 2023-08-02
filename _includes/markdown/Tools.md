This document provides an overview of Kanopi tooling. Generally, these tools are encouraged or required to be used in favor of others. Ideally, Kanopi would like to use the same (or very similar) tools across all projects. This helps minimize switching costs for developers when moving through tasks or even whole projects. 

- Rules governing client site tools are less flexible. Internal, experimental projects are more flexible.
- Inherited support client sites are more flexible. How much work is put into “standardizing” an inherited support site will depend on budget and project deadline needs.
- Several of these tools work in conjunction. For example, a WP Engine-hosted site might run Tugboat previews, which may then run BackstopJS visual regression testing.

<h2 id="kanopi-computers" class="anchor-heading">Kanopi Computers</h2>

<h3 id="software-management" class="anchor-heading">Software Management</h3>

As a part of Kanopi's default laptop configuration via our mobile device management (MDM) system, users are not system administrators on their devices by default. Configuring and managing machines relies on the following applications.

- **Privileges App** - allows users to request `sudo` power. Disabling administrator rights by default prevents unintended machine changes. It also helps to prevent malicious actors from doing bad things. To activate administrative privileges, click the lock icon in your Dock. Once activated, you will receive admin (and therefore `sudo` ) rights for up to two hours. This is typically a required step when running commands in the terminal and elsewhere.

<h3 id="ides" class="anchor-heading">Code Editors/IDEs</h3>

Kanopi’s preferred code editor is Visual Studio Code. Some developers use PHPStorm; however, it is preferable to use VS Code as that is the officially supported code editor in Kanopi. 

VS Code can be configured using any plugins desired, of course. Some extensions are strongly recommended:

- [PHPCS](https://marketplace.visualstudio.com/items?itemName=shevaua.phpcs) (note: while this exact extension is not required, projects should generally meet [phpcs standards](https://github.com/squizlabs/PHP_CodeSniffer) for their CMS of choice. In other words, there must be some way for code to achieve `phpcs` standards.) In general, projects should adhere to the standard [WP phpcs standards](https://github.com/WordPress/WordPress-Coding-Standards). Various support projects may have custom standards applied — check the README for any differences in a given project.
- [WordPress Snippets (for WordPress developers)](https://marketplace.visualstudio.com/items?itemName=wordpresstoolbox.wordpress-toolbox)
- [Git Graph](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph)
- [PHP Debug](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug)

<h2 id="git-local-workflow" class="anchor-heading">Git & Local Workflow</h2>

<h3 id="git-version-control" class="anchor-heading">Git: Version Control</h3>

[Git](https://git-scm.com/) - Kanopi’s preferred version control. Kanopi encourages developers to use the command line for interacting with Git. GUIs are permitted but may not be supported internally.

[GitHub](https://github.com/) - Kanopi’s preferred version control management system. All developers must have a GitHub account. Kanopi uses various teams within the GitHub organization. Developer GitHub accounts will be added to teams and repositories as needed. You may use your existing GitHub account or optionally set one up that is Kanopi-specific.

[Left Hook](https://github.com/evilmartians/lefthook) - A tool that runs commit hooks on code. For example, commit hooks can be configured to run PHPCS. If PHPCS fails, the commit cannot be pushed to the remote repo. It can be installed via npm or brew if necessary for a given project.

See [Version Control](../Engineering-Best-Practices/version-control) for more information.

<h3 id="cms-base-builds" class="anchor-heading">CMS Base Builds & New Site Scaffolding</h3>

For new builds, Kanopi has several starter kits and base builds available. These starter kits help scaffold a new site quickly and in a standardized Kanopi way. Support projects can emulate the starter kits for a most ideal scaffolding setup - although again, budget and client needs dictate the setup for these projects.

The goal is to avoid building the same content types and components and build processes on almost every site. Reusable code allows the sales department the freedom to bid more competitively.

<h3 id="wordpress" class="anchor-heading">WordPress</h3>

[Kanopi WP Basebuild](https://github.com/kanopi/wp-basebuild) - Developers can use WP Basebuild to quickly create WordPress sites with recommended tooling and many best practices already in place. WP Basebuild contains a full and robust suite of the tools used for sites, such as Docksal, Bootstrap, and Kanopi Pack.

<h3 id="drupal" class="anchor-heading">Drupal</h3>

On the Drupal side, the [base starter](https://github.com/kanopi/drupal-starter) includes the configuration, templates, and styling needed to jump-start a Drupal 9 build.  

**Drupal starters:**

- [https://github.com/kanopi/drupal-starter](https://github.com/kanopi/drupal-starter)
- [https://github.com/kanopi/drupal-acquia](https://github.com/kanopi/drupal-acquia)

**More Drupal tools:**

- Kanopi Design Component Library is an initiative to bridge Kanopi’s Figma and Storybook component library. There are two iterations.
    - KDCL Basic
    - KDCL - which will be connected to Figma through Style Dictionary and Figma Tokens
- [Kanponents](https://github.com/kanopi/kanponents/), which houses common UCSF paragraphs
- [Wanzer](https://github.com/kanopi/wanzer/), a module that installs UCSF content types and related building blocks
- [Toland](https://github.com/kanopi/toland), a base theme with common UCSF styles.

<h2 id="composer" class="anchor-heading">Composer: Package/Dependency Managers</h2>

[Composer](https://getcomposer.org/) - Composer manages PHP dependencies. Both Drupal and WordPress projects can be easily managed using Composer. The exact version of composer used changes from project to project, and some projects will have specific version requirements.

<h3 id="wordpress-composer" class="anchor-heading">WordPress</h3>

- WP Basebuild comes with composer preinstalled.
- [WordPress Packagist](https://wpackagist.org/) provides a Composer repository that mirrors all public WordPress plugins and themes.

<h3 id="drupal-starter" class="anchor-heading">Drupal</h3>

- [Drupal Packages](https://www.drupal.org/docs/develop/using-composer/using-packagesdrupalorg) provides various composer packages that can be installed to a Drupal project.

<h3 id="composer-resources" class="anchor-heading">More Composer resources:</h3>

- [Kanopi Packagist](https://github.com/kanopi/composer) - Houses custom Kanopi projects using a composer-based repository.
- [Composer Basics Handout by Mike Anello from Drupal Easy](https://docs.google.com/document/d/1nVvkkwmQDcsVGuDd1kFsL8Y5r88Qxy_gh7K4fUocC1o/edit?pli=1#heading=h.8o41ox9fsnf)

<h2 id="docksal-local" class="anchor-heading">Docksal: Local Development Environments</h2>

Kanopi’s preferred local development environment is [Docksal](https://docksal.io/). Docksal builds and interacts with virtual environments that match production as closely as possible. Sean works on Docksal directly as a contributor, so an excellent Docksal resource already lives in-house.

Docksal uses Docker and Docker Compose to create fully containerized environments for projects. All the configurations and requirements are packaged into one container. These sites can then be spun up without additional local machine installations. Project-specific tools/dependencies are installed and run in the Docksal container and are independent of the local machine. 

For example, suppose a terminus or composer command must be run from a local site. Normally terminus or composer would need to be installed on the local machine. The commands are unavailable until installed on the local machine. With Docksal, those dependencies are available in the Docksal container. The commands can be run and used from the Docksal container, regardless if they are installed on the local machine or not.

For help and assistance with Docksal, please see the [#dev-pipeline Slack channel](https://kanopi.slack.com/archives/C7SJ3QK46).

<h3 id="docksal-key-features" class="anchor-heading">Key Features Of Docksal</h3>

- Docksal is not specialized in either WordPress or Drupal
- Docksal is lightweight and not resource intensive
- All projects/containers are independent of each other
- Each project/container can have its own stack requirements and different versions of the same service
- Each container/project can be managed independently and extended with any service
- Tools such as Composer, Drush, Drupal Console, Terminus, npm, and WP-CLI are built-in. These tools don’t need to be separately installed and managed on the local machine.

<h2 id="task-runners" class="anchor-heading">Task Runners</h2>

- The WP Basebuild uses Webpack as [Kanopi Pack](https://github.com/kanopi/kanopi-pack). This is Kanopi’s preferred method of task running.
    - Resources: [Kanopi Pack Theme Integration](https://snippets.cacher.io/snippet/c0ba9321b584bfa1c756)
- Through inherited support sites, other task runners such as Grunt, Gulp, and standard Webpack are frequently supported.

<h2 id="linting" class="anchor-heading">Linting & Code Quality</h2>

<h3 id="styleint" class="anchor-heading">Stylelint</h3>

[https://stylelint.io/](https://stylelint.io/) - a CSS linting tool that ensures code quality and standardization.

<h3 id="eslint" class="anchor-heading">ESLint</h3>

[https://eslint.org/](https://eslint.org/) - A JavaScript linting tool that ensures code quality and standardization.

<h3 id="sonarqube" class="anchor-heading">Sonarqube</h3>

[SonarQube](https://www.sonarqube.org/) - A PHP code quality and code security tool. [https://github.com/kanopi/sonarqube-report](https://github.com/kanopi/sonarqube-report) can be used to run a SonarQube report within projects.

<h2 id="cms-cli-tools" class="anchor-heading">CMS Command Line Tools</h2>

- [WP-CLI](https://wp-cli.org/) - A command line interface for WordPress. This is an extremely powerful tool that allows imports, exports, running custom scripts, and more — all via the command line.
- [Drush](https://docs.drush.org/en/8.x/) - Drush is a command line shell and Unix scripting interface for Drupal. Drush core ships with lots of useful commands and generators. Similarly, it runs update.php, executes SQL queries, runs content migrations, and misc utilities like cron or cache rebuild.

<h2 id="continuous" class="anchor-heading">Continuous Integration/Continuous Deployment (CI/CD)</h2>

Some of the things that can be done with CI/CD include:

- BackstopJS visual regression testing
- Lighthouse and pa11y accessibility testing
- PHP code quality tools such as PHPCS, PHPD, PHPStan, and SonarQube
- Asset compilation with grunt, gulp, webpack, etc.

<h3 id="circleci" class="anchor-heading">CircleCI</h3>

[https://github.com/kanopi/circleci-orbs](https://github.com/kanopi/circleci-orbs) 

CircleCI is a continuous integration (CI) tool. CircleCI facilitates code deployments to various environments and automated tooling workflows. Orbs are a set of automated and reusable tasks that can be implemented to help speed up different tasks within a Circle buil

See [CircleCI]({{ site.baseurl }}/circleci) for more information.

<h3 id="automated-cms-updates" class="anchor-heading">Automated CMS Updates</h3>

[https://github.com/kanopi/cms-updates](https://github.com/kanopi/cms-updates)

Automated CMS updates automatically run CMS updates on Drupal and WordPress sites. The automated script runs to update core and contributed files and libraries and creates a testing environment (whether that’s a multidev, Tugboat preview, or another environment depends on the project). Finally, the automated CMS tool alerts the development team that the environment is ready for review, typically through a pull request.

<h3 id="github-dependabot" class="anchor-heading">GitHub Dependabot</h3>

Dependabot provides automated dependency updates built into GitHub. Dependabot will scan a repository looking for outdated dependencies. It will then create a pull request in the repository, requesting updates. Dependabot PRs are mostly useful when dealing with custom build tools and custom-written code.

There is not much point in Dependabot PRs for updating the tooling within a third-party plugin, for example, as that third-party code is entirely within the control of the said third party. In other words, when Dependabot opens a PR to update Gulp in Alice’s Amazing WordPress Plugin, that PR can be closed without comment. It’s up to Alice to update the plugin.

<h2 id="testing-qa" class="anchor-heading">Testing and QA</h2>

<h3 id="accessibility-testing" class="anchor-heading"> Accessibility Testing</h3>

A note about accessibility testing — automated testers do not capture all potential issues. Some level of manual testing is required.

**Automated Testing**

The following automated tools are used to test accessibility. As part of continuous integration, CircleCI can run some automated testing via orbs.

[https://intranet.kanopi.com/departments/technology/resources/a11y_teaching__learning_audit_process__tools](https://intranet.kanopi.com/departments/technology/resources/a11y_teaching__learning_audit_process__tools)

- Command Line Tools
    - [pa11y](https://pa11y.org/) (often, but not always, configured through CircleCI)
- Browser-Based Tools
    - [WAVE](https://wave.webaim.org/)
    - [Deque Axe Devtools](https://www.deque.com/axe/devtools/)
    - [SiteImprove](https://www.siteimprove.com/integrations/browser-extensions/)

**Manual Testing**

Manual testing includes:

- Reading the page with a screen reader. Testing with a screen reader does require some special learning and direction. The following tools are free.
    - [NVDA](https://www.notion.so/Tools-e69903a57ad44d91981c19e5e45c33be)
    - [Chrome voiceover](https://www.notion.so/Tools-e69903a57ad44d91981c19e5e45c33be)
    - [MacOS voiceover](https://www.notion.so/Tools-e69903a57ad44d91981c19e5e45c33be)
- Testing heading levels and ensuring headings occur in descending order (h1, h2, h3, h4, h5, h6).
    - [Headings Map for Chrome](https://chrome.google.com/webstore/detail/headingsmap/flbjommegcjonpdmenkdiocclhjacmbi?hl=es) or [Headings Map for Firefox](https://addons.mozilla.org/en-us/firefox/addon/headingsmap/) - A browser extension that displays the heading structure of a webpage.

**Internal Resources**

Internal resources for accessibility testing:

- [#accessibility](https://kanopi.slack.com/archives/C8VPZKYKG) Kanopi channel

<h3 id="tugboat" class="anchor-heading">Tugboat: Preview Build Service</h3>

Tugboat is a special preview building service used on sites that do not have Pantheon multidevs. Pantheon multidev environments mirror the purpose of Tugboat. 

Tugboat builds a testing environment that is completely separate from the production environment. This is helpful for various workflows and client testing. For projects configured with Tugboat, Tugboat Previews are automatically built when a pull request is opened. Additional tools, like Lighthouse and Visual Diffs regressions, can be configured to run against Tugboat Previews.

[http://intranet.kanopi.com/download/.attachments/tugboatpaulzenbusiness20210512mp4](http://intranet.kanopi.com/download/.attachments/tugboatpaulzenbusiness20210512mp4)

Note, Tugboat will not persist database changes across builds. If the content is modified in a Tugboat environment — such as adding ACF fields, deleting or moving pages, or modifying a menu — these changes will not persist. Tugboat previews shut down after periods of inactivity. If they are reactivated, Tugboat spins up completely fresh, pulling a new copy of the database from production.

This limitation may complicate client testing. If many changes are required within a Tugboat preview, it may make sense to split the commits/deployments up. 

For example, when adding a new post type Fax Machines to Bob’s Beeper Emporium site — it may make sense to:

- Create a commit defining the post type and ACF fields.
- Get that commit all the way up to production.
- Enter some data into production.

Tugboat previews will then build with the expected data.

<h3 id="backstop-js" class="anchor-heading">BackstopJS: Visual Regression Testing</h3>

BackstopJS provides visual regression testing to ensure code changes don’t have unforeseen repercussions. Backstop essentially takes screenshots of a website before and after changes are applied. It then compares the two sets of screenshots, providing a “visual diff” for QA and testing. Backstop is useful for CSS changes, plugin updates, and third-party script updates. 

Sometimes, visual regression testing is baked into local workflows or Tugboat.

- [BackstopJS](https://github.com/kanopi/backstop-local)
- Cacher Snippets
    - CircleCI: [https://snippets.cacher.io/snippet/1cd8e1241cde4a889e13](https://snippets.cacher.io/snippet/1cd8e1241cde4a889e13)
    - htpasswd: [https://snippets.cacher.io/snippet/7fccb3d8ec3b4a5df739](https://snippets.cacher.io/snippet/7fccb3d8ec3b4a5df739)

<h3 id="lighthouse" class="anchor-heading">Lighthouse: Performance, A11Y, SEO Testing</h3>

The goal of the Lighthouse initiative is for Kanopi's portfolio and sites to rank in the top 25% and better of all sites on the internet against Google Lighthouse tests. Existing clients have chosen to work with Kanopi based on our Lighthouse scores.

Tests can be manually run using browser plugins or a CLI tool. Lighthouse tests can also be added to continuous integration tests on sites that have multidev environments.

Kanopi maintains a Lighthouse Dashboard for easy access to score information for these “index” sites. 

- The dashboard is located at [https://lighthouse-eos.netlify.app/](https://lighthouse-eos.netlify.app/) (open / sesame)
- The GitHub repository is located at [https://github.com/kanopi/lh_eos](https://github.com/kanopi/lh_eos)

<h2 id="hosting-environments" class="anchor-heading">Hosting Environments</h2>

Kanopi works with various hosting environments. Every hosting environment and the tools provided in each environment are slightly different. The optimal setup also differs per project, based on the hosting environment used and that particular client's needs.

- [Pantheon](https://pantheon.io) (WP & Drupal, WP multisites, & headless WP & Drupal)
- [Acquia](https://www.acquia.com/) (Drupal, Drupal multisites, and headless Drupal)
- [WP Engine](https://wpengine.com/) (WP, WP Multisites, and headless WP)
- [PlatformSH](https://platform.sh/) (Everything and more)
- [Contegix](https://www.contegix.com/) (Everything and more)
- [Kinsta](https://kinsta.com/), [Flywheel](https://getflywheel.com/), and [Linode](https://www.linode.com/) _(hosts that are used only if a client comes into support with a hosting contract already in place)_

<h3 id="pantheon" class="anchor-heading">Pantheon</h3>

**Features**

- **Multidev environments** provide standalone, separate environments for each code change. Often, Github pull requests are configured to create a multidev when opened.
    - Example: two separate PRs create two separate multidev environments, allowing the work to be reviewed in parallel.
- **Terminus** is a command line interface that provides advanced interaction with Pantheon. Terminus provides access to almost everything in the Pantheon Dashboard in a terminal, as well as scripting and much more.
    - Example: take a backup of a Pantheon site through the command line, without going through the dashboard.
- **Quicksilver** hooks into Pantheon workflows to automate Pantheon WebOps workflow. This allows the platform to run selected scripts automatically every hour, or when a team member triggers the corresponding workflow.
    - Example: clearing out real users from a WP database when the database is copied from live to dev.

**Access**

To see all projects in Pantheon, use the Kanopi organization dashboard. Developers/managers are not added to individual projects within Pantheon. When a developer is added to the Kanopi organization, they automatically get access to all Kanopi projects.

<h3 id="wp-engine" class="anchor-heading">WP Engine</h3>

**Features**

- Typically set up with three separate environments — development, staging, and production.
- An “Advanced” tab in the dashboard allows the running of WP-CLI (but not SSH) commands.
- With WP Engine, projects most frequently include Tugboat. This allows more flexible testing and deployment processes, as nothing is tied together when testing or deploying. Tugboat on WP Engine can essentially replicate the multidev feature on Pantheon, allowing multiple PRs to be reviewed in parallel without interfering with each other.

<h2 id="misc-tools" class="anchor-heading">Miscellaneous Tools</h2>

<h3 id="cacher" class="anchor-heading">Cacher: Code Snippet Organizer</h3>

Cacher is Kanopi’s preferred method of sharing code snippets. It integrates with most IDEs, has a web app and browser extensions, and can sync to GitHub Gists. Cacher allows easy collaboration and discussion with other developers. When asking “how do I X…” — Cacher is a great place to start searching for Kanopi-specific workflows, snippets, and walkthroughs.

<h3 id="design-tools" class="anchor-heading">Design Tools</h3>

- [Zeplin](https://zeplin.io/) - Kanopi’s preferred method of sharing final design assets. Zeplin gives developers a single, clean source of truth.
- [Figma](https://www.figma.com/) - A collaborative interface and design tool. It’s free to install and is frequently used to deliver prototypes from the design team.