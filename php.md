---
page: php
title: PHP
nav: PHP
group: navigation
layout: default
subnav:
  - title: Performance
    tag: performance
  - title: Design Patterns
    tag: design-patterns
  - title: Security
    tag: security
  - title: Unit and Integration Testing
    tag: unit-testing
  - title: Code Style & Documentation
    tag: code-style
  - title: Libraries and Frameworks
    tag: libraries
---

<div class="docs-section">
		{% capture php %}{% include markdown/PHP.md %}{% endcapture %}
		{{ php | markdownify }}
</div>