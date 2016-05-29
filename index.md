---
page: introduction
title: Introduction
nav: Home
group: navigation
weight: 1
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
updated: 6 Oct 2014
---

<div class="toc">
	<header>
		<h2>Table of Contents</h2>
	</header>

	<div class="col">
		<h3><a href="{{ HOME_PATH }}#top">Introduction</a></h3>
		<ul>
			<li><a href="{{ HOME_PATH }}#audience">Audience</a></li>
			<li><a href="{{ HOME_PATH }}#goal">Goal</a></li>
			<li><a href="{{ HOME_PATH }}#philosophy">Philosophy</a></li>
			<li><a href="{{ HOME_PATH }}#contributing">Contributing</a></li>
		</ul>
	</div>

    <div class="col">
		<h3><a href="{{ HOME_PATH }}markup/#top">Markup</a></h3>
		<ul>
			<li><a href="{{ HOME_PATH }}markup/#philosophy">Philosophy</a></li>
			<li><a href="{{ HOME_PATH }}markup/#html5-structural-elements">HTML5 Structural Elements</a></li>
			<li><a href="{{ HOME_PATH }}markup/#classes-ids">Classes and ID's</a></li>
			<li><a href="{{ HOME_PATH }}markup/#accessibility">Accessibility</a></li>
			<li><a href="{{ HOME_PATH }}markup/#progressive-enhancement">Progressive Enhancement</a></li>
		</ul>
	</div>

	    <div class="col">
  		<h3><a href="{{ HOME_PATH }}css/#top">CSS</a></h3>

  		<ul>
  			<li><a href="{{ HOME_PATH }}css/#philosophy">Philosophy</a></li>
  			<li><a href="{{ HOME_PATH }}css/#syntax-formatting">Syntax and Formatting</a></li>
  			<li><a href="{{ HOME_PATH }}css/#documentation">Documentation</a></li>
  			<li><a href="{{ HOME_PATH }}css/#performance">Performance</a></li>
  			<li><a href="{{ HOME_PATH }}css/#responsive-websites">Responsive Websites</a></li>
  			<li><a href="{{ HOME_PATH }}css/#frameworks">Frameworks</a></li>
  		</ul>
  	</div>

	<div class="col">
		<h3><a href="{{ HOME_PATH }}php/#top">PHP</a></h3>
		<ul>
			<li><a href="{{ HOME_PATH }}php/#performance">Performance</a></li>
			<li><a href="{{ HOME_PATH }}php/#design-patterns">Design Patterns</a></li>
			<li><a href="{{ HOME_PATH }}php/#security">Security</a></li>
			<li><a href="{{ HOME_PATH }}php/#code-style">Code Style & Documentation</a></li>
			<li><a href="{{ HOME_PATH }}php/#unit-testing">Unit and Integration Testing</a></li>
			<li><a href="{{ HOME_PATH }}php/#libraries">Libraries and Frameworks</a></li>
		</ul>
	</div>

	<div class="col">
		<h3><a href="{{ HOME_PATH }}version-control/#top">Version Control</a></h3>
		<ul>
			<li><a href="{{ HOME_PATH }}version-control/#structure">Structure</a></li>
			<li><a href="{{ HOME_PATH }}version-control/#workflows">Workflows</a></li>
		</ul>
	</div>

	<div class="col">
		<h3><a href="{{ HOME_PATH }}javascript/#top">JavaScript</a></h3>
		<ul>
			<li><a href="{{ HOME_PATH }}javascript/#performance">Performance</a></li>
			<li><a href="{{ HOME_PATH }}javascript/#design-patterns">Design Patterns</a></li>
			<li>
				<a href="{{ HOME_PATH }}javascript/#unit-and-integration-testing">Unit and Integration Testing</a>
			</li>
			<li><a href="{{ HOME_PATH }}javascript/#code-style">Code Style & Documentation</a></li>
			<li><a href="{{ HOME_PATH }}javascript/#libraries">Libraries</a></li>
		</ul>
	</div>

	<div class="col">
		<h3><a href="{{ HOME_PATH }}tools/#top">Tools</a></h3>
		<ul>
			<li><a href="{{ HOME_PATH }}tools/#local-development">Local Development Environments</a></li>
			<li><a href="{{ HOME_PATH }}tools/#task-runners">Task Runners</a></li>
			<li><a href="{{ HOME_PATH }}tools/#package-managers">Package/Dependency Managers</a></li>
			<li><a href="{{ HOME_PATH }}tools/#version-control">Version Control</a></li>
			<li><a href="{{ HOME_PATH }}tools/#command-line">Command Line Tools</a></li>
		</ul>
	</div>

	<div class="col">
		<h3><a href="{{ HOME_PATH }}structure/#top">Project Structure</a></h3>
		<ul>
			<li><a href="{{ HOME_PATH }}structure/#integrations">Third-Party Integrations</a></li>
			<li><a href="{{ HOME_PATH }}structure/#modular-code">Modular Code</a></li>
			<li><a href="{{ HOME_PATH }}structure/#dependencies">Dependencies</a></li>
			<li><a href="{{ HOME_PATH }}structure/#file-organization">File Organization</a></li>
		</ul>
	</div>

</div>

<div class="docs-section">
		{% capture introduction %}{% include markdown/Introduction.md %}{% endcapture %}
		{{ introduction | markdownify }}
</div>
