We version control all projects at 10up using [Git](http://git-scm.com/). Version control allows us to track codebase history, maintain parallel tracks of development, and collaborate without stomping out each others changes.

### Structure

The key philosophy that drives our repository structure is *we don't version control things that are version controlled elsewhere*. This means we don't version control WordPress core files or third party plugins. If we are building a theme, we version control only the theme and deploy to the themes directory. Similarly, if we are building a plugin, we version control only the plugin and deploy to the plugins directory. Rather than version control third party libraries, we use [package managers](/Engineering-Best-Practices/tools/#package-managers) to include those dependencies. There are of course exceptions to this.

The counter argument to this philosophy is "what if the latest version of ______ breaks the site? How will we revert to a working state if we don't version control WordPress core and plugins?". WordPress core is backwards compatible, and we believe in trusting it the same way we trust PHP or MySQL. Similarly, we only install and recommend plugins that we trust. These best practices coupled with our talented engineers gives us confidence that our code will work with core and plugin updates. We still test major updates to plugins and core on staging first. If we discover code in core or a plugin that has issues, we try our best to correct that code and push the changes upstream giving back to the open source community.

<h3 id="workflows">Workflows {% include Util/top %}</h3>

At 10up we consider standardizing a workflow to be a very important part of the development process. Utilizing an effective workflow ensures efficient collaboration and quicker project onboarding. For this reason we use the following workflows company-wide both for internal and client projects.

#### Commits

Commits should be small and independent items of work. Distinct items of work are essential in keeping features separate, which will aid in reversing or rolling back commits if necessary or pushing specific features forward.

#### Merges

In order to avoid large merge conflicts, merges should occur early and often. Do not wait until a feature is complete to merge ```master``` into it.

#### Themes

All new development should take place on feature branches that branch off ```master```. When a new feature or bugfix is complete, we will do a non-fast-forward merge (```--no-ff``` flag) from that branch to ```staging``` to verify the feature or fix on the stage environment.

When things are absolutely ready to go, we'll deploy the feature or fix by performing a non-fast-forward merge from that branch to ```master```

##### Branching

All theme projects will treat the ```master``` branch as the canonical source for live, production code. Feature branches will branch off ```master``` and should always have ```master``` merged back into them before requesting peer code review and before deploying to any staging environments.

All staging branches will branch off ```master``` as well, and should be named ```staging``` or ```stage-{environment}``` for consistency and clarity. Staging branches will never be merged into any other branches. The ```master``` branch can be merged into both staging and feature branches to keep them up-to-date.

###### Complex Feature Branches

In some cases, a feature will be large enough to warrant multiple developers working on it at the same time. In order to enable testing the feature as a cohesive unit and avoid merge conflicts when pushing to ```staging``` and ```master``` it is recommended to create a feature branch to act as a staging area. We do this by branching from ```master``` to create the primary feature branch, and then as necessary, create additional branches from the feature branch for distinct items of work. When individual items are complete, merge back to the feature branch. To pull work from ```master```, merge ```master``` into the feature branch and then merge the feature branch into the individual branches. When all work has been merged back into the feature branch, the feature branch can then be merged into ```staging``` and ```master``` as an entire unit of work.

##### Working with WordPress.com VIP

In a VIP environment, we want every commit to the theme's Subversion repository to be matched 1:1 with a merge commit on our Beanstalk Git repository. This means we add a step to our deployment above: Create a diff between the branch and ```master``` before merging. We can apply this diff as a patch to the VIP Subversion repository.

Using non-fast-forward merges allows us to easily track various changes back in the history tree.

##### Backporting VIP

In the event that VIP makes a change to the repository, we'll capture the diff of their changeset and import it to our development repository by:

* Grabbing the diff of their changes
* Creating a new ```vip-rXXXX``` branch off ```master```
* Applying the diff to the new branch
* Merging the branch to ```staging```, using a non-fast-forward merge
* Merging the branch back to ```master```, again using a non-fast-forward merge

##### Archiving Branches

This workflow will inevitably build up a large list of branches in the repository. To prevent a large number of unused branches living in the repository, we'll archive them after feature development is complete.

After a branch has been merged back to both ```staging``` and ```master``` (i.e. it's been deployed to the production site), we will:

* Check out the head of the branch
* Tag the branch as ```archive/{branch-name}```
* Push tags to Beanstalk
* Move to another branch (doesn't matter which)
* Delete the branch (both on local and Beanstalk)

The tag will allow us to easily return to the branch should we need to for any reason.

#### Plugins

Unlike theme development, the ```master``` branch represents a stable, released, versioned product. Ongoing development will happen on a ```develop``` branch, which is itself branched off ```master```.

##### Branching

New features should be branched off ```develop``` and, once complete, merged back into ```develop``` using a non-fast-forward merge.

##### Deploying

When a new version is complete and ready to ship, update version slugs on ```develop```, then merge ```develop``` back to ```master``` (using a non-fast-forward merge). Tag the merge commit with the version number being released so we can keep track of where new versions land.

Once a version is tagged and released, the tag must never be removed. If there is a problem with the project requiring a re-deployment, create a new version and tag to reflect the change.
