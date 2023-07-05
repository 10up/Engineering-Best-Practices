---
page: 
title: Markup
nav: 
group: 
weight: 4
layout: default
subnav:
  - title: Philosophy
    tag: philosophy
  - title: Accessibility
    tag: accessibility
  - title: Structure
    tag: structure
  - title: Media
    tag: media
  - title: SVG
    tag: svg
updated: 14 October 2019
---

<div class="docs-section">
		{% capture markup %}{% include markdown/Markup.md %}{% endcapture %}
		{{ markup | markdownify }}
</div>
