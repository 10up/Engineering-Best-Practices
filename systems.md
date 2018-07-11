---
page: systems
title: Systems
nav: Systems
group: navigation
weight: 10
layout: default
subnav:
  - title: Nginx
    tag: nginx
  - title: PHP-FPM
    tag: php-fpm
  - title: MySQL
    tag: mysql
updated: 25 June 2018
---

<div class="docs-section">
		{% capture systems %}{% include markdown/Systems.md %}{% endcapture %}
		{{ systems | markdownify }}
</div>