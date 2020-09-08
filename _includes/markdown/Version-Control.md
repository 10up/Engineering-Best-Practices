We version control all projects at 10up using [Git](https://git-scm.com/). Version control allows us to track codebase history, maintain parallel tracks of development, and collaborate without stomping out each other's changes.

<h2 id="structure-package-management" class="anchor-heading">Structure and Package Management {% include Util/link_anchor anchor="structure-package-management" %} {% include Util/top %}</h2>

We structure our projects in such a way that we are not version controlling third party code, rather, they are included via a package manager. For PHP, we use [Composer](https://getcomposer.org/) to manage PHP dependencies (also see [package managers](/Engineering-Best-Practices/tools/#package-managers)) e.g. WordPress core itself, plugins, and themes. Dependency management structuring is explained more in the [Structure](https://10up.github.io/Engineering-Best-Practices/structure/#composer-based-project-structure) section.

We also do not commit compiled files (JS/CSS). This saves us from having to deal with people forgetting to compile files and large merge conflicts. Instead, we generate compile files during deployment.

<h2 id="workflows" class="anchor-heading">Workflows {% include Util/link_anchor anchor="workflows" %} {% include Util/top %}</h2>

At 10up we consider standardizing a workflow to be a very important part of the development process. Utilizing an effective workflow ensures efficient collaboration and quicker project onboarding. For this reason, we use the following workflows company-wide both for internal and client projects.

### Commits

Commits should be small and independent items of work, containing changes limited to a distinct idea. Distinct commits are essential in keeping features separate, pushing specific features forward, or reversing or rolling back code if necessary.

#### Commit Messages

The first line of a commit message is a brief summary of the changeset, describing the expected result of the change or what is done to affect change.

```sh
git log --oneline -5

# fca8925 Update commit message best practices
# 19188a0 Add a note about autoloading transients
# 9630552 Fix a typo in PHP.md
# 2309e04 Remove extra markdown header hash
# 5cd2604 Add h3 and h4 styling
```

This brief summary is always required. It is around 50 characters or less, always stopping at 70. The high visibility of the first line makes it critical to craft something that is as descriptive as possible within space limits.

```sh
git commit -m "Add an #Element.matches polyfill to support old IE"
```

Separated from the summary by a blank line is the longer description. It is optional and includes more details about the commit and its repercussions for developers. It may include links to the related issue, side effects, other solutions that were considered, or backstory. A longer description may be useful during the merge of a feature branch, for example.

```sh
git commit

# Merge 'feature/polyfill' into gh-pages
#
# matches and closest are used to simplify event delegation:
# http://caniuse.com/#feat=matchesselector
# http://caniuse.com/#feat=element-closest
# Promise and fetch are used to simplify async/ajax functionality:
# http://caniuse.com/#feat=promises
# http://caniuse.com/#feat=fetch
```

### Merges

In order to avoid large merge conflicts, merges should occur early and often. Do not wait until a feature is complete to merge ```trunk``` into it. Merging should be done as non-fast-forwards (`--no-ff`) to ensure a record of the merge exists.

### Protecting the ```trunk``` Branch

We recommend for all repositories to be configured so the ```trunk``` branch is protected to prevent direct pushes. All merges should be made through a pull request, which ensures all code changes are peer reviewed before merging to prevent unintentional code reversions. Additionally, protecting branches provides the following benefits:

* Prevents the trunk branch from being accidentally deleted by other engineers
* Prevents force-pushes to the branch, overwriting the history

### Themes

All new development should take place on feature branches that branch off ```trunk```. When a new feature or bugfix is complete, we will do a non-fast-forward merge from that branch to ```staging``` to verify the feature or fix on the stage environment.

When things are absolutely ready to go, we'll deploy the feature or fix by performing a non-fast-forward merge from that branch to ```trunk```

#### Branching

All theme projects will treat the ```trunk``` branch as the canonical source for live, production code. Feature branches will branch off ```trunk``` and should always have ```trunk``` merged back into them before requesting peer code review and before deploying to any staging environments.

All staging branches will branch off ```trunk``` as well, and should be named ```staging``` or ```stage-{environment}``` for consistency and clarity. Staging branches will never be merged into any other branches. The ```trunk``` branch can be merged into both staging and feature branches to keep them up-to-date.

#### Complex Feature Branches

In some cases, a feature will be large enough to warrant multiple developers working on it at the same time. In order to enable testing the feature as a cohesive unit and avoid merge conflicts when pushing to ```staging``` and ```trunk``` it is recommended to create a feature branch to act as a staging area. We do this by branching from ```trunk``` to create the primary feature branch, and then as necessary, create additional branches from the feature branch for distinct items of work. When individual items are complete, merge back to the feature branch. To pull work from ```trunk```, merge ```trunk``` into the feature branch and then merge the feature branch into the individual branches. When all work has been merged back into the feature branch, the feature branch can then be merged into ```staging``` and ```trunk``` as an entire unit of work.

#### Deleting or Archiving and Deleting Branches

This workflow will inevitably build up a large list of branches in the repository. To prevent a large number of unused branches living in the repository, we'll delete or archive and delete them after feature development is complete.

### Deleting branches
When projects use non-ff merges to trunk, we can safely delete feature branches because all commits are preserved and can be located from the merge commit.

* Move to another branch (doesn't matter which): eg. `git checkout trunk`
* Delete the branch (both on local and remote): `git branch -D branch-name; git push :branch-name`

### Archiving and Deleting branches
When projects use squash merges to create a more streamlined history in trunk, we should archive branches before deleting them to preserve the commit history. Branch tag archives also prove a useful history of branches, in case a specific branch is needed later.

* Move to another branch (doesn't matter which): eg. `git checkout trunk`
* Archive the branch: `git tag archive/branch-name branch-name`
* Delete the branch (both on local and remote): `git branch -D branch-name; git push :branch-name`
* Push the archive tag: `git push origin archive/branch-name`


### Plugins

Unlike theme development, the `trunk` branch represents a stable, released, versioned product. Ongoing development will happen in feature branches branched off a `develop` branch, which is itself branched off `trunk`. This pattern is commonly referred to as [the Gitflow workflow](https://www.atlassian.com/git/tutorials/comparing-workflows#gitflow-workflow).

#### Branching

New features should be branched off `develop` and, once complete, merged back into `develop` using a non-fast-forward merge.

#### Deploying

When `develop` is at a state where it's ready to form a new release, create a new `release/<version>` branch off of `develop`. In this branch, you'll bump version numbers, update documentation, and generally prepare your release. Once ready, merge your release branch (using a non-fast-forward merge) into `trunk` and tag the release:

```sh
git tag -a <version> -m "Tagging <version>"
```

> **Note:** Once a version is tagged and released, the tag must never be removed. If there is a problem with the project requiring a re-deployment, create a new version and tag to reflect the change.

Finally, merge `trunk` into `develop` so that `develop` includes all of the work that was done in your release branch and is aware of the current state of `trunk`.

##### Semantic Versioning

As we assign version numbers to our software, we follow [the Semantic Versioning pattern](http://semver.org/), wherein each version follows a MAJOR.MINOR.PATCH scheme:

* **MAJOR** versions are incremented when breaking changes are introduced, such as functionality being removed or otherwise major changes to the codebase.
* **MINOR** versions are incremented when new functionality is added in a backwards-compatible manner.
* **PATCH** versions are incremented for backwards-compatible bugfixes.

Imagine Jake has written a new plugin: 10upalooza. He might give his first public release version **1.0.0.** After releasing the plugin, Jake decides to add some new (backwards-compatible) features, and subsequently releases version **1.1.0**. Later, Taylor finds a bug and reports it to Jake via GitHub; no functionality is added or removed, but Jake fixes the bug and releases version **1.1.1**.

Down the road, Jake decides to remove some functionality or change the way some functions are used. Since this would change how others interact with his code, he would declare this new release to be version **2.0.0**, hinting to consumers that there are breaking changes in the new version of his plugin.

##### Change Logs

If your plugin  is being distributed, it's strongly recommended that your repository contains a `CHANGELOG.md` file, written around [the Keep A Changelog standard](http://keepachangelog.com/).

Maintaining an accurate, up-to-date change log makes it easy to see – in human-friendly terms – what has changed between releases without having to read through the entire Git history. As a general rule, every merge into the `develop` branch should contain at least one line in the change log, describing the feature or fix.
