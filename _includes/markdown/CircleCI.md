CircleCI is a tool used for continuous integration. It allows projects to build, test, and deploy projects across multiple platforms. Comparative tools include GitHub ACtions, Jenkins, Buddy, etc. CircleCI is part of the devops chain in development.

## Configuration

* `.circleci` directory, typically at the root of the project, contains a `config.yml` file consisting of YAML.
* YAML anchors provide a way to add reusable variables. E.g., `production-remote-user: &production-remote-user "someuserhere"` will allow 
* Consists of "jobs" and "workflows" -- workflows orchestrate jobs.

## Links

* [Kanopi CircleCI Orbs](https://github.com/kanopi/circleci-orbs)
* [Orbs Channel](https://kanopi.slack.com/archives/CUBC4Q1B4)
* [CircleCI Dashboard](https://app.circleci.com)
* [CircleCI video walkthrough with Sean (2018)](https://intranet.kanopi.com/culture/kanopi_news/teaching_tuesday/sean_circle_ci_12042018)

## Examples

Examples of things CircleCI can do:

* Deploy to various environments, such as development, staging, and production.
* Build assets for various projects.
* Run automated tests such as accessibility testing or performance testing.
* Post a notification to Slack when a job has succeeded or failed.
* Run automated CMS updates.

## Accessing CircleCI

* Log in via GitHub username to [the CircleCI dashboard](https://app.circleci.com).
* Most projects are located under `kanopi` -- however, some projects run under another, separate organization. Use the dropdown in the upper top left to access different organizations.
* The `projects` link shows all available CircleCI projects. Helpfully, the most recently run projects will float to the top of the list.

## Scripts

CircleCI can run custom scripts -- for example, running a Pantheon-specific deployment workflow with various Terminus commands. Scripts are typically included under `.circleci/scripts/`. 

## Environment Variables

When an environment variable is needed, CircleCI provides [an interface to add environment variables](https://app.circleci.com/settings/project/github/kanopi/epac/environment-variables). This is highly preferable as opposed to adding environment variables to the repository.

## Updating Orbs & Validating Configuration

* CircleCI offers a [local command line interface](https://circleci.com/docs/local-cli/). This CLI offers a number of useful tools -- chiefly, the ability to test and validate your local configuration before deploying. Running `circleci config validate` is an easy (and very fast) way to test out your current configuration. Check this [helpful Loom walkthrough](https://www.loom.com/share/7ee53c43663d46028343b30d3edc824c).
* When making updates -- you can typically set `dry-run: true` within the job steps to run the job without making actual changes. This is especially helpful when making any change that could impact an environment currently in use (especially production).

## Common Problems

* **General Failure Troubleshooting Steps**: 
	* Rerun the job via CircleCI buttons to ensure it was not a momentary glitch.
	* Check the status of CircleCI, Pantheon, WP Engine, etc. Basically, make sure the failure is not a temporary hiccup. Retry again later once the status issues have resolved.
	* Yelp in the [#dev-pipeline Slack channel](https://kanopi.slack.com/archives/C7SJ3QK46) for assistance.
* **Missing Files on Rsync Based Deployment**: Check the `exclude_files.txt` list (typically located either in the root directory or `.circleci` directory) and make sure the file, or a pattern relating to that file, is not excluded from deployment.
* **"Cannot access install" on WP Engine**: Make sure that `code@kanopistudios.com` has been added to the WP Engine account users. In most cases, this must be done by the client as we do not have full owner access to many WP Engine accounts. Additionally, make sure that the `deployment-context` contains `kanopi-code-wpengine`.
* **Permission Denied**: the script permissions in `.circleci` directory likely need to be reset. It can be reset as part of the local Docksal spin-up. [Example](https://github.com/kanopi/r4d-lnct/blob/main/.docksal/commands/init-site#L28): `find .circleci/scripts/ -type f -exec chmod 755 {} +`

## Helpful Cacher Links

To search any Cacher guid, open your Cacher app or visit the in-browser dashboard.

* WordPress Pantheon Deployments -- guid:9d9fe6e5a9e04486b342
* Rsync Deployments -- guid:d7826476c6df06564391
* Testing Tools Setup -- guid:3e2b58807472ac95685d
* And of course, there are a number of CircleCI-relevant cacher snippets under the CircleCI category available for perusal.