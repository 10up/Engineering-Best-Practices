---
page: web-vitals
title: Web Vitals
nav: Web Vitals
group: navigation
weight: 10
layout: default
subnav:
  - title: Largest Contentful Paint
    tag: lcp
  - title: Cumulative Layout Shift
    tag: cls
  - title: First Input Delay
    tag: fid
  - title: Measuring / Tools
    tag: measuring
updated: 28 May 2021
---

<div class="docs-section">
		{% capture web-vitals %}{% include markdown/Web-Vitals.md %}{% endcapture %}
		{{ web-vitals | markdownify }}
</div>