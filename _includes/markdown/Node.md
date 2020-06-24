## Node Versions

Node applications should **only** use Active LTS or Maintenance LTS versions. Odd-numbered versions (11, 13, 15) should not be used.  When starting a new project always use the most recent Active/Maintenance LTS version. For more information about Node.js version visit [Node.js releases page](https://nodejs.org/en/about/releases/).

![Node.js releases](https://raw.githubusercontent.com/nodejs/Release/master/schedule.svg?sanitize=true)


Every project should declare its supported node version in package.json by specifying the [engines](https://docs.npmjs.com/files/package.json#engines) property.

```json
{ 
  "engines" : {
    "node" : ">=12.0.0"
  }
}
```

Additionally, it is recommended to create a `.nvmrc` file with the officially supported node version of the project. This allows those using `nvm` to run `nvm use` to switch the node version. We also recommend setting up [shell integration](https://github.com/nvm-sh/nvm#deeper-shell-integration) to automatically switch node versions when changing directories.

## Security Updates

The JavaScript ecosystem is constantly evolving, several security patches are released almost every day for the hundreds of npm packages used across 10up’s projects. Keeping packages up-to-date is a time-consuming process considering how fast new patches are released. This section brings a few  best practices and processes to better maintain our JavaScript codebase.

### Node.js updates

The production Node.js server should always be running a LTS version in order to receive extended security updates. Additionally, production servers running Node.js should be regularly updated to the latest minor version automatically.

### Dependencies Updates

We advise project teams to constantly update all npm dependencies for security fixes and general updates. This can be done through the `npm audit fix` command. Typically, we recommend leveraging GitHub/GitLab bots (like [Dependabot](https://github.com/dependabot)) that automatically create Pull Requests to update dependencies, instead of having engineers running npm audits manually.

Before enabling an automated bot to handle dependencies updates, each project team should manually update all dependencies with the help of `npm audit fix` to reduce the numbers of PRs created by the bot. Using an automated bot to handle package updates ensures the project team is constantly up-to-speed with the latest version of each package being used. Even if there are changes required to make a new version of a package work, these changes tend to be much easier when the version jump is smaller.

Additionally, we recommend running `npm audit` through [audit-ci](https://www.npmjs.com/package/audit-ci) and block Pull Requests/Merge Requests from being merged/approved until high and severe security vulnerabilities are patched.

## Deploying Node.js

We recommend shipping Node.js applications through the official Docker containers which will always pull the latest Node.js minor version on every new deployment.
