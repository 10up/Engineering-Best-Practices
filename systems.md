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
  - title: Memcached and Redis
    tag: memcached-and-redis
  - title: Load Balancing
    tag: load-balancing
updated: 13 December 2019
---

<div class="docs-section">
		{% capture systems %}{% include markdown/Systems.md %}{% endcapture %}
		{{ systems | markdownify }}
</div>
