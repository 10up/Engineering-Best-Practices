---
page: nginx
title: Nginx
nav: Nginx
group: navigation
weight: 10
layout: default
subnav:
  - title: Installation
    tag: installation
  - title: Configuration Files
    tag: configuration-files
  - title: Security
    tag: security
  - title: Performance
    tag: performance
  - title: Caching
    tag: caching
updated: 25 June 2018
---

<div class="docs-section">
		{% capture nginx %}{% include markdown/Nginx.md %}{% endcapture %}
		{{ nginx | markdownify }}
</div>