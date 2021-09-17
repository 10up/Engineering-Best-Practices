---
page: gutenberg
title: Gutenberg
nav: Gutenberg
group: navigation
weight: 4
layout: default
subnav:
  - title: Framing Gutenberg
    tag: framing-gutenberg
  - title: Gutenberg Components
    tag: gutenberg-components
  - title: Including / Excluding Blocks
    tag: inc-excl-blocks
updated: 17 September 2021

---

<div class="docs-section">
		{% capture gutenberg %}{% include markdown/Gutenberg.md %}{% endcapture %}
		{{ gutenberg | markdownify }}
</div>