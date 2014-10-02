---
page: introduction
title: Introduction
nav: Home
group: navigation
layout: default
subnav:
  - title: Audience
    tag: audience
  - title: Goal
    tag: goal
  - title: Philosophy
    tag: philosophy
  - title: Contributing
    tag: contributing
---

<div class="docs-section">
		{% capture introduction %}{% include markdown/Introduction.md %}{% endcapture %}
		{{ introduction | markdownify }}
</div>