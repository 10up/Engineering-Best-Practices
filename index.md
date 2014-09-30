---
page: introduction
title: Introduction
group: navigation
layout: default
---

<div class="section">
	<div class="col">
		{% capture introduction %}{% include markdown/Introduction.md %}{% endcapture %}
		{{ introduction | markdownify }}
	</div>
</div>

<div class="heading" id="php">
	<h2>PHP</h2>
</div>

<div class="section">
	<div class="col">
		{% capture php %}{% include markdown/PHP.md %}{% endcapture %}
		{{ php | markdownify }}
	</div>
</div>

<div class="heading" id="javascript">
	<h2>JavaScript</h2>
</div>

<div class="section">
	<div class="col">
		{% capture javascript %}{% include markdown/JavaScript.md %}{% endcapture %}
		{{ javascript | markdownify }}
	</div>
</div>

<div class="heading" id="version-control">
	<h2>Version Control</h2>
</div>

<div class="section">
	<div class="col">
		{% capture workflow %}{% include markdown/Version-Control.md %}{% endcapture %}
		{{ workflow | markdownify }}
	</div>
</div>

<div class="heading" id="tools">
	<h2>Tools</h2>
</div>

<div class="section">
	<div class="col">
		{% capture tools %}{% include markdown/Tools.md %}{% endcapture %}
		{{ tools | markdownify }}
	</div>
</div>
