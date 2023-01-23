Kanopi Studios uses Git to version control all project code and hosts distributed version control on Github. Alternative remote repository platforms may be used based on client project requirements, including BitBucket and GitLab. 

<h2 id="kanopi-structure-and-package-management" class="anchor-heading">Structure and Package Management</h2>

We strive to structure our projects in a standardized way. Inherited support projects may not adhere to all structure standards; it is encouraged to bring these projects into alignment with the Kanopi standard structure as budget and timelines permit. New Build projects should follow these guidelines.

### What Is Tracked In Version Control

- custom code (e.g., themes, plugins, modules),
- README files,
- `make` files,
- composer.json and composer.lock files,
- package.json and package.lock files,
- configuration, including deployment (i.e., CircleCI) and project setup (i.e., Docksal files),
- linting, and
- other system files

### Example of items to gitignore:


```
mysql.sql (any db files)
uploads
local config files
vendor
node_modules
any large media files like videos
```
### Resources:

- Starter repository .gitignore examples:
    - [WordPress .gitignore file](https://github.com/kanopi/wp-starter/blob/main/.gitignore)
    - [Drupal .gitignore file](https://github.com/kanopi/drupal-starter/blob/main/.gitignore)
- [Creating and Configuring a Global .gitignore](https://snippets.cacher.io/snippet/21733480f0c1c64f0d93)

### Guidelines:

- Include third-party code via package managers and do not version control.
    - PHP: Composer
    - Plugins: WPackagist
- Compiled files (e.g., JS/CSS) should be built during deployment and not be committed to the project.
- The canonical source for production code should exist on the branch named **main**.
- The main branch should be protected so that merges cannot happen unless the code has been reviewed by at least one reviewer.

<aside class="green">
    <p>💡 Legacy projects may use alternative names for the primary branch, e.g., master or development. Check the project README or consult with the project Technical Lead to confirm the primary branch names for a project.</p>
</aside>

<h2 id="kanopi-vc-workflows" class="anchor-heading">Workflows</h2>

At Kanopi, we consider a standardized workflow a very important part of the development process. Utilizing an effective, consistent workflow ensures efficient collaboration and quicker project onboarding. For this reason, we use the following workflows company-wide for internal and client projects.

### Branching

All projects will treat the main branch as the canonical source for live production code. Feature branches will branch off main and should always have main merged back into them before requesting peer code review and before deploying to any staging environments.
#### Branching Naming Conventions

We want a one-to-one relationship with tasks and tickets, which means branches should be small and encompass only the task at hand. If you are working on a sub-task or a feature with dependencies, use the parent task ID.

**Task** (feature, bug, or hotfix) / **project management system** + **task ID** - **short description**

Example branch naming:

- feature/twXXXX-short-desc
- bug/twXXXX-short-desc
- hotfix/twXXXX-short-desc

**Teamwork Task ID:**

![Teamwork ID](../img/tw-id.png)

Common Project Management System abbreviations:

- **tw = Teamwork**
- **ji = Jira**

#### Special Cases:

- **WordPress plugin updates**
    - Use the `feature` prefix with the year and month, e.g.: `feature/tw{{task ID}}/plugin-{{YYYYMM}}`

#### Guidelines:

- All new development should occur on feature branches that branch off the default branch (main).
- Use a new branch for every task/feature.
    - Review the project-level documentation and repository READMEs for project-specific workflows.
    - Contact the project Technical Lead if you have any questions on project branching requirements.
- Regularly merge the remote main branch to your local main branch.
    
    ```bash
    $ git checkout main
    $ git pull [or] git fetch && git merge
    ```
    
- Regularly delete your merged branches on both local and remote repositories.
    - The reviewer of the Pull Request on GitHub will delete the branch upon merging into the remote main branch. This can be configured to delete on merge automatically.  Please contact #helpdesk to configure if it is not on your project.
    - When a Pull Request is approved, you are safe to delete the branch on your local machine:
    
    ```bash
    ## Delete a Local Branch in Git
    $ git branch -d name-of-local-feature-branch
    
    ## Note: exercise caution when forcefully deleting a local branch with the following command. This will result in losing untracked work.
    ## -- delete --force a Local Branch in Git
    git branch -D name-of-local-feature-branch
    ```
    
#### Complex Feature Branching

In some cases, a feature will be large enough to warrant multiple developers working on it at the same time. In order to test the feature as a cohesive unit and avoid merge conflicts when pushing to the staging and main branches, it is recommended to create a parent feature branch to act as a staging area. 

1. Branch from the main branch to create the parent feature branch and then, as necessary, 
2. Create child feature branches from the parent feature branch for distinct items of work. 
3. When child branch tasks are complete, merge them back to the parent feature branch. 

To pull work from main:

1. Merge main into the parent feature branch, then
2. Merge the parent feature branch into the individual child feature branches. 

When all work has been merged back into the parent feature branch:

1. The parent feature branch can then be merged into the staging or main branches as an entire unit of work.

![Complex Merge Strategy Diagram](../img/complex-branching.png)

### Commits

Commits should be small and independent items of work, containing changes limited to a distinct idea. Distinct commits are essential in keeping features separate, pushing specific features forward, or reversing or rolling back code if necessary.
#### Commit Message Format

Each commit message consists of a **brief summary** and optional **description.**

**1. Brief Summary**

The first line of a commit message is a brief summary of the changeset, describing the expected result of the change or what is done to affect the change.

```bash
$ git log --oneline -5

# fca8925 Update commit message best practices
# 19188a0 Add a note about autoloading transients
# 9630552 Fix a typo in PHP.md
# 2309e04 Remove extra markdown header hash
# 5cd2604 Add h3 and h4 styling
```
**2. Description (optional)**

Separated from the summary by a blank line is the longer description. It is optional and includes more details about the commit and any repercussions for developers. It may include links to the related issue, side effects, other solutions that were considered, or a backstory. A longer description may be useful during the merge of a feature branch, for example.

#### Example Commit Messages:

```bash
$ git commit -m "feat: Add an #Element.matches polyfill to support old IE"

$ git log
commit 11112222333344444
Author: Your Name you@example.com
Date:   Fri Jan 06 20:18:15 2023

feat: Add an #Element.matches polyfill to support old IE
```

```bash
$ git commit -m "fix: ensure post type is set before querying" 
-m "Exits Relevanssi search results filter by type if the post type query variable is not available. Corrects Missing index notice."

$ git log
commit 11112222333344444
Author: Your Name you@example.com
Date:   Fri Jan 06 20:18:15 2023

fix: ensure post type is set before querying

Exits Relevanssi search results filter by type if the post type query variable is not available. 
Corrects Missing index notice.
```
#### Guidelines

- A brief summary is always required.
- Aim for around 50 characters or less, always stopping at 70.
- The high visibility of the first line makes it critical to craft something that is as descriptive as possible within space limits.
- The summary may be prefixed with a commit type that easily identifies the focus of the change. Common commit types include:
    - **build**: Changes that affect the build system or external dependencies (example scopes: gulp, webpack, npm)
    - **ci**: Changes to our CI configuration files and scripts
    - **docs**: Documentation only changes
    - **feat**: A new feature
    - **fix**: A bug fix
    - **perf**: A code change that improves performance
    - **refactor**: A code change that neither fixes a bug nor adds a feature
    - **test**: Adding missing tests or correcting existing tests
    - **plugin**: Updating or adding a new plugin or module
    - **standards:** Formatting changes resulting from applying coding standards (e.g., phpcs, phpcbf)
    
    (source: [Angular docs](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#type))
<aside class="green">
<p>💡 When applying coding standards (e.g., PHPcs), add formatting changes to a separate commit. This practice will help developers complete code reviews.</p>
</aside>

### Pull Request Process

**Developer Responsibilities**

It's an important part of controlling change management that we ensure that there is some separation of responsibilities in the code review process. Our preferred division of responsibilities is as follows.

- PR creation - Developer
- Resolving merge conflict - Developer
- Code review - Technical Lead or Peer Developer
- Merging into the main branch - Technical Lead or Developer*
- Change implementation - Developer
- Deployment - Technical Lead or Developer*

*Not all projects have a Technical Lead. Any project developer at the request of a Project Manager or Technical Lead may assume these responsibilities.
#### Before Creating a Pull Request

1. Merge the remote main branch into your local feature branch and resolve any conflicts.

```bash
## Pull the latest version of the remote main branch
$ git checkout main
$ git pull

## Merge main into your local branch
$ git checkout name-of-local-feature-branch
$ git merge main

## Push feature branch up to remote repo
$ git push origin name-of-local-feature-branch
```
#### Creating a Pull Request (PR)

PRs are created within GitHub and include a Kanopi description template by default. 

Please see [the section resources](#pr-resources) for instructions on creating a PR in GitHub. 

The PR template includes the following content:

1. Description
    1. User Story
    2. A few sentences describing the overall goals of the pull request commits. What is the current behavior of the app? What is the updated/expected behavior with this PR? Include your acceptance criteria; this information can often be copy/pasted from the task. 
2. Affected URL(s): a link to the relevant multidev or test site. The URLs provided should be in a state that allows verification for both PR Review and QA. 
3. Related Tickets: a link to the related Teamwork task.
4. Steps to Validate: a list of steps to validate work.
5. Deployment Notes: information relevant to deploying the changes in the PR.
#### Guidelines:

- You can use a Pull Request Draft to check if your request will pass the automated checks. For Pantheon sites, a multidev creation can be triggered when a PR draft is generated.
- Make sure you are comparing the correct branches, e.g., main/master to feature branch.
- Resolve any conflicts before assigning a reviewer.
- Assign a PR Reviewer when the PR is ready for code review.
- Transition the Teamwork task to Code Review and assign the task to the PR Reviewer.
#### Resources: {#pr-resources}

- [GitHub: Creating a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request#creating-the-pull-request)
- [Kanopi Studios PR Template](https://gist.github.com/kwhite/79f59eba02c7ee511d03110ae70d78c5)

### Reviewing a Pull Request (PR)

A PR is always required for code changes merged to the main branch. The PR reviewer can be a developer on the project or the project Technical Lead. The peer doing the review should have some familiarity with the project in question; this is an important discussion and quality control step, not a process box to check.

#### Guidelines:

- Suggest line item changes where it is necessary/appropriate
- Ensure domain-specific coding standards and best practices are implemented.

#### Resources:

- [Repo: Review pull requests](https://github.com/skills/review-pull-requests)


### Merges

In order to avoid large merge conflicts, merges should occur early and often. Do not wait until a feature is complete to merge main into it. Merging should be done as non-fast-forwards (`--no-ff`) to ensure a record of the merge exists.
#### Merging Strategy

Kanopi implements a “**squash** and **merge”** strategy for incorporating changes from a pull request. 

#### Guidelines

- The developer who created the PR is responsible for resolving all merge conflicts.
- Do not merge a branch into main until the feature is stable and preferably production-ready.
- Use squash and merge workflow for merges to the main branch.
- The developer who merges should delete/prune the merged branch immediately after the merge is successful.

#### Resources:

- [GitHub: **Squash and merge your commits**](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges#squash-and-merge-your-commits)
- [GitHub: **Configuring commit squashing for pull requests**](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/configuring-commit-squashing-for-pull-requests)
- [Dealing with non-fast-forward errors](https://docs.github.com/en/get-started/using-git/dealing-with-non-fast-forward-errors)

### Deployment Strategies

Please review project documentation and READMEs for project-specific deployment workflows. The standard Kanopi deployment process utilizes **Tagged Releases.**

#### Tagged Releases

Deployments to staging and production environments are triggered when Git tags are pushed to a project’s remote repository. Tagged releases follow specific naming conventions, please review project documentation for the naming conventions used to trigger automated deploys, examples include:

- Semantic Versioning
- `{ environment }-date`, e.g., production-20221203

Git tags can be applied and published via the command line or through a project’s GitHub repository. The project GitHub Release interface is the recommended approach to managing and publishing Git tags. 

#### Guidelines:

- Include a descriptive title for the tag release, e.g., WP Core 6.1.
- Consider using the Generated Release Notes. These notes list the feature branches and PRs included in the release. If the Generated Release Notes are not used, please provide links to the Teamwork tasks and PRs for all features included in the release.

#### Resources:

- [GitHub: About Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
- [GitHub: Managing releases in a repository](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)

### Remote Repository Management

#### Deleting Branches

A feature branch workflow will inevitably build up a large list of branches in the repository. To prevent many unused branches from living in the repository, we'll delete feature branches once they are merged into the main branch. 

When projects use non-ff merges to main, we can safely delete feature branches because all commits are preserved and can be located from the merge commit. Project repositories should be configured to delete branches when a Pull Request is merged automatically. 

To remove outdated branches on your local machine that are no longer in use or available in the remote repository, consider using `git fetch --prune`  . 

#### Resources:

- [GitHub: **Managing the automatic deletion of branches**](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-branches)
- [BitBucket: Prune, see Discussion](https://www.atlassian.com/git/tutorials/git-prune#:~:text=git%20fetch%20%2D%2Dprune%20is,use%20on%20the%20remote%20repository.)