# General Workflow for Theme Development

All new development should take place on feature branches that branch off ```master```. When a new feature or bugfix is complete, we will do a non-fast-forward merge from that branch to ```staging``` to verify the feature/fix on the stage environment.

When things are absolutely ready to go, we'll deploy the fix by performing a non-fast-forward merge from that branch to ```master```

## Branching

All theme projects will treat the ```master``` branch as the canonical source for live, production code. Feature branches will branch off ```master``` and should always have ```master``` merged back into them before requesting peer code review and before deploying to any staging environments.

All staging branches will branch off ```master``` as well, and should be named ```staging``` or ```stage-{environment}``` for consistency and clarity. Staging branches will never be merged into any other branches. The ```master``` branch can be merged into both staging and feature branches to keep them up-to-date.

## Working with VIP

In a VIP environment, we want every commit to the theme's Subversion repository to be matched 1:1 with a merge commit on our Beanstalk Git repository. This means we add a step to our deployment above: Create a diff between the branch and ```master``` before merging - we can apply this diff as a patch to the VIP Subversion repository
Using non-fast-forward merges allows us to easily track various changes back in the history tree.

## Backporting VIP

In the event that VIP makes a change to the repository, we'll capture the diff of their changeset and import it to our development repository by:

* Grabbing the diff of their changes
* Creating a new ```vip-rXXXX``` branch off ```master```
* Applying the diff to the new branch
* Merging the branch to ```staging```, using a non-fast-forward merge
* Merging the branch back to ```master```, again using a non-fast-forward merge

## Archiving Branches

This workflow will inevitably build up a large list of branches in the repository. To prevent a large number of unused branches living in the repository, we'll archive them after feature development is complete.

After a branch has been merged back to both ```staging``` and ```master``` (i.e. it's been deployed to the production site), we will:

* Check out the head of the branch
* Tag the branch as ```archive/{branch-name}```
* Push tags to Beanstalk
* Move to another branch (doesn't matter which)
* Delete the branch (both on local and Beanstalk)

The tag will allow us to easily return to the branch should we need to for any reason.

# General Workflow for Plugin Development

Unlike theme development, the ```master``` branch represents a stable, released, versioned product. Ongoing development will happen on a ```develop``` branch, which it itself branched off ```master```.

## Branching

New features should be branched off ```develop``` and, once complete, merged back into ```develop``` using a non-fast-forward merge.

## Deploying

When a new version is complete and ready to ship, update version slugs on ```develop```, then merge ```develop``` back to ```master``` (using a non-fast-forward merge). Tag the merge commit with the version number being released so we can keep track of where new versions land.

Once a version is tagged and released, the tag must never be removed. If there is a problem with the project requiring a re-deployment, create a new version and tag to reflect the change.