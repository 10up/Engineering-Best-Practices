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
updated: 5 July 2023
---

<div class="toc">
	<header>
		<h2>Table of Contents</h2>
	</header>

	<div class="cols">
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
			<h3><a href="{{ site.baseurl }}/systems/#top">System Architecture</a>{% include Util/status status="in-progress" %}</h3>
			<ul>
				<li><a href="{{ site.baseurl }}/#">PHP</a></li>
				<li><a href="{{ site.baseurl }}/#">Twig</a></li>
				<li><a href="{{ site.baseurl }}/#">CSS</a></li>
				<li><a href="{{ site.baseurl }}/#">Javascript</a></li>
			</ul>
		</div>

		<div class="col">
			<h3><a href="{{ site.baseurl }}/Accessibility/#top">Accessibility</a>{% include Util/status status="in-progress" %}</h3>
			<ul>
				<li>Coming Soon...</li>
			</ul>
		</div>

		<div class="col">
			<h3><a href="{{ site.baseurl }}/seo/#top">SEO</a>{% include Util/status status="updated" %}</h3>
			<ul>
				<li><a href="{{ site.baseurl }}/seo/#basics">SEO Basics</a></li>
				<li><a href="{{ site.baseurl }}/seo/#meta">Head Data</a></li>
				<li><a href="{{ site.baseurl }}/seo/#searchability">Searchability</a></li>
				<li><a href="{{ site.baseurl }}/seo/#design">Design</a></li>
				<li><a href="{{ site.baseurl }}/seo/#other">Other Factors</a></li>
				<li><a href="{{ site.baseurl }}/seo/#yoast">Yoast (WordPress)</a></li>
				<li><a href="{{ site.baseurl }}/seo/#rankmath">RankMath (WordPress)</a></li>
				<li><a href="{{ site.baseurl }}/seo/#metatag">Metatag (Drupal)</a></li>
			</ul>
		</div>

		<div class="col">
			<h3><a href="{{ site.baseurl }}/version-control/#top">Version Control</a></h3>
			<ul>
				<li><a href="{{ site.baseurl }}/version-control/#kanopi-structure-and-package-management">Structure and Package Management</a></li>
				<li><a href="{{ site.baseurl }}/version-control/#kanopi-vc-workflows">Workflows</a></li>
			</ul>
		</div>

		<div class="col">
			<h3><a href="{{ site.baseurl }}/performance/#top">Performance</a>{% include Util/status status="in-progress" %}</h3>
			<ul>
				<li><a href="{{ site.baseurl }}/performance/#baseline">Best Practices</a></li>
				<li><a href="{{ site.baseurl }}/performance/#core-web-vitals">Core Web Vitals</a></li>
			</ul>
		</div>

		<div class="col">
			<h3><a href="{{ site.baseurl }}/security/#top">Security</a>{% include Util/status status="in-progress" %}</h3>
			<ul>
				<li>Coming Soon...</li>
			</ul>
		</div>

		<div class="col col--tools">
			<h3><a href="{{ site.baseurl }}/tools/#top">Tools</a>{% include Util/status status="updated" %}</h3>
			<ul>
				<li><a href="{{ site.baseurl }}/tools/#kanopi-computers">Kanopi Computers</a></li>
				<li><a href="{{ site.baseurl }}/tools/#git-local-workflow">Git & Local Workflow</a></li>
				<li><a href="{{ site.baseurl }}/tools/#composer">Composer</a></li>
				<li><a href="{{ site.baseurl }}/tools/#docksal-local">Docksal</a></li>
				<li><a href="{{ site.baseurl }}/tools/#task-runners">Task Runners</a></li>
				<li><a href="{{ site.baseurl }}/kanopipack/#top">Kanopi Pack</a></li>
				<li><a href="{{ site.baseurl }}/tools/#linting">Linting & Code Quality</a></li>
				<li><a href="{{ site.baseurl }}/tools/#cms-cli-tools">CMS Command Line Tools</a></li>
				<li><a href="{{ site.baseurl }}/tools/#continuous">Continuous Integration/Continuous Deployment (CI/CD)</a></li>
				<a href="{{ site.baseurl }}/circleci/#top">CircleCI</a>
				<li><a href="{{ site.baseurl }}/tools/#testing-qa">Testing & QA</a></li>
				<li><a href="{{ site.baseurl }}/tools/#hosting-environments">Hosting Environments</a></li>
				<li><a href="{{ site.baseurl }}/tools/#misc-tools">Miscellaneous Tools</a></li>
			</ul>
		</div>

		<div class="col">
			<h3><a href="{{ site.baseurl }}/migrations/#top">Migration</a></h3>
			<ul>
				<li>Coming Soon...</li>
			</ul>
		</div>
	</div>
	
</div>

<div class="docs-section">
		{% capture introduction %}{% include markdown/Introduction.md %}{% endcapture %}
		{{ introduction | markdownify }}
</div>
