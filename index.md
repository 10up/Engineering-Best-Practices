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
		<h3><a href="{{ site.baseurl }}#top">Introduction</a></h3>
		<ul>
			<li><a href="{{ site.baseurl }}#audience">Audience</a></li>
			<li><a href="{{ site.baseurl }}#goal">Goal</a></li>
			<li><a href="{{ site.baseurl }}#philosophy">Philosophy</a></li>
			<li><a href="{{ site.baseurl }}#contributing">Contributing</a></li>
		</ul>
	</div>

    <div class="col">
		<h3><a href="{{ site.baseurl }}/markup/#top">Markup</a></h3>
		<ul>
			<li><a href="{{ site.baseurl }}/markup/#philosophy">Philosophy</a></li>
			<li><a href="{{ site.baseurl }}/markup/#html5-structural-elements">HTML5 Structural Elements</a></li>
			<li><a href="{{ site.baseurl }}/markup/#classes-ids">Classes and ID's</a></li>
			<li><a href="{{ site.baseurl }}/markup/#accessibility">Accessibility</a></li>
			<li><a href="{{ site.baseurl }}/markup/#progressive-enhancement">Progressive Enhancement</a></li>
		</ul>
	</div>

	    <div class="col">
  		<h3><a href="{{ site.baseurl }}/css/#top">CSS</a></h3>

  		<ul>
  			<li><a href="{{ site.baseurl }}/css/#philosophy">Philosophy</a></li>
  			<li><a href="{{ site.baseurl }}/css/#syntax-formatting">Syntax and Formatting</a></li>
  			<li><a href="{{ site.baseurl }}/css/#documentation">Documentation</a></li>
  			<li><a href="{{ site.baseurl }}/css/#performance">Performance</a></li>
  			<li><a href="{{ site.baseurl }}/css/#responsive-websites">Responsive Websites</a></li>
  			<li><a href="{{ site.baseurl }}/css/#frameworks">Frameworks</a></li>
  		</ul>
  	</div>

	<div class="col">
		<h3><a href="{{ site.baseurl }}/php/#top">PHP</a></h3>
		<ul>
			<li><a href="{{ site.baseurl }}/php/#performance">Performance</a></li>
			<li><a href="{{ site.baseurl }}/php/#design-patterns">Design Patterns</a></li>
			<li><a href="{{ site.baseurl }}/php/#security">Security</a></li>
			<li><a href="{{ site.baseurl }}/php/#code-style">Code Style & Documentation</a></li>
			<li><a href="{{ site.baseurl }}/php/#unit-testing">Unit and Integration Testing</a></li>
			<li><a href="{{ site.baseurl }}/php/#libraries">Libraries and Frameworks</a></li>
		</ul>
	</div>

	<div class="col">
		<h3><a href="{{ site.baseurl }}/version-control/#top">Version Control</a></h3>
		<ul>
			<li><a href="{{ site.baseurl }}/version-control/#structure">Structure</a></li>
			<li><a href="{{ site.baseurl }}/version-control/#workflows">Workflows</a></li>
		</ul>
	</div>

	<div class="col">
		<h3><a href="{{ site.baseurl }}/javascript/#top">JavaScript</a></h3>
		<ul>
			<li><a href="{{ site.baseurl }}/javascript/#performance">Performance</a></li>
			<li><a href="{{ site.baseurl }}/javascript/#design-patterns">Design Patterns</a></li>
			<li>
				<a href="{{ site.baseurl }}/javascript/#unit-and-integration-testing">Unit and Integration Testing</a>
			</li>
			<li><a href="{{ site.baseurl }}/javascript/#code-style">Code Style & Documentation</a></li>
			<li><a href="{{ site.baseurl }}/javascript/#libraries">Libraries</a></li>
		</ul>
	</div>

	<div class="col">
		<h3><a href="{{ site.baseurl }}/tools/#top">Tools</a></h3>
		<ul>
			<li><a href="{{ site.baseurl }}/tools/#local-development">Local Development Environments</a></li>
			<li><a href="{{ site.baseurl }}/tools/#task-runners">Task Runners</a></li>
			<li><a href="{{ site.baseurl }}/tools/#package-managers">Package/Dependency Managers</a></li>
			<li><a href="{{ site.baseurl }}/tools/#version-control">Version Control</a></li>
			<li><a href="{{ site.baseurl }}/tools/#command-line">Command Line Tools</a></li>
			<li><a href="{{ site.baseurl }}/tools/#a11y-testing">Accessibility Tools</a></li>
		</ul>
	</div>

	<div class="col">
		<h3><a href="{{ site.baseurl }}/structure/#top">Project Structure</a></h3>
		<ul>
			<li><a href="{{ site.baseurl }}/structure/#file-organization">File Organization</a></li>
			<li><a href="{{ site.baseurl }}/structure/#dependencies">Dependencies</a></li>
			<li><a href="{{ site.baseurl }}/structure/#integrations">Third-Party Integrations</a></li>
			<li><a href="{{ site.baseurl }}/structure/#modular-code">Modular Code</a></li>
		</ul>
	</div>

	<div class="col">
		<h3><a href="{{ site.baseurl }}/systems/#top">Systems</a></h3>
		<ul>
			<li><a href="{{ site.baseurl }}/systems/#nginx">Nginx</a></li>
			<li><a href="{{ site.baseurl }}/systems/#php-fpm">PHP-FPM</a></li>
			<li><a href="{{ site.baseurl }}/systems/#mysql">MySQL</a></li>
		</ul>
	</div>

</div>

<div class="docs-section">
		{% capture introduction %}{% include markdown/Introduction.md %}{% endcapture %}
		{{ introduction | markdownify }}
</div>
