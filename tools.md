---
page: tools
title: Tools
nav: Tools
group: navigation
weight: 8
layout: default
subnav:
  - title: Kanopi Computers
    tag: kanopi-computers
  - title: Git & Local Workflow
    tag: git-local-workflow
  - title: Composer
    tag: composer
  - title: Docksal
    tag: docksal-local
  - title: Task Runners
    tag: task-runners
  - title: Kanopi Pack
    slug: kanopipack
  - title: Linting & Code Quality
    tag: linting
  - title: CMS Command Line Tools
    tag: cms-cli-tools
  - title: Continuous Integration/Continuous Deployment (CI/CD)
    tag: continuous
  - title: Circle CI
    slug: circleci
  - title: Testing & QA
    tag: testing-qa
  - title: Hosting Environments
    tag: hosting-environments
  - title: Miscellaneous Tools
    tag: misc-tools
updated: 4 July 2023
---

<div class="docs-section">
		{% capture tools %}{% include markdown/Tools.md %}{% endcapture %}
		{{ tools | markdownify }}
</div>