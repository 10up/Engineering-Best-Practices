---
page: migrations
title: Migrations
nav: Migrations
group: navigation
weight: 8
layout: default
subnav:
  - title: Migration Plan
    tag: migration-plan
  - title: Writing Migration Scripts
    tag: writing-migration-scripts
  - title: Thou Shalt Not Forget
    tag: thou-shalt-not-forget
  - title: Potential Side Effects
    tag: potential-side-effects
updated: 1 Sep 2016
---

<div class="docs-section">
	{% capture migrations %}{% include markdown/Migrations.md %}{% endcapture %}
	{{ migrations | markdownify }}
</div>
