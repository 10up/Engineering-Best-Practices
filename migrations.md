---
page: migrations
title: Migrations
nav: Migrations
group: navigation
weight: 2
layout: default
subnav:
  - title: Performance
    tag: performance
  - title: Design Patterns
    tag: design-patterns
  - title: Security
    tag: security
  - title: Code Style & Documentation
    tag: code-style
  - title: Unit and Integration Testing
    tag: unit-testing
  - title: Libraries and Frameworks
    tag: libraries
updated: 1 Sep 2016
---

<div class="docs-section">
	{% capture migrations %}{% include markdown/Migrations.md %}{% endcapture %}
	{{ migrations | markdownify }}
</div>
