<h2 id="philosophy" class="anchor-heading">Philosophy</h2>
At WisdmLabs, we aim to create the best possible experience for both our clients and their customers; not for the sake of using cool, bleeding edge technologies that may not have widespread browser support. Our markup embodies this approach.

### Principles
Markup is intended to define the structure and outline of a document and to offer semantic structure for the document's contents. Markup should not define the look and feel of the content on the page beyond the most basic structural concepts such as headers, paragraphs, and lists.

At WisdmLabs, our projects are often large and ongoing. As such, it's imperative that we engineer projects to be maintainable. From a markup perspective, we do this by adhering to the following principles:

### Semantic
At WisdmLabs, we pride ourselves in writing clean, semantic markup. Semantic markup can be defined as: "the use of HTML markup to reinforce the semantics, or meaning, of the information in web pages rather than merely to define it's presentation or look. Semantic HTML is processed by traditional web browsers as well as by many other user agents. CSS is used to suggest its presentation to human users" (definition from Wikipedia -[https://en.wikipedia.org/wiki/Semantic_HTML](https://en.wikipedia.org/wiki/Semantic_HTML)).

Semantic elements are elements with clearly defined meaning to both the browser and the developer. Elements like ```<header>```, ```<nav>```, ```<footer>```, or ```<article>``` do a much better job of explaining the content that is contained within the element than ```<span>``` or ```<div>```. This does not mean that we do not use ```<div>```s in our markup, only that we prefer the right tool (or in this case semantic element) for the job.


### Minimal &amp; Valid
Websites should be written using the least amount of markup that accomplishes the goal. In the interest of engineering maintainable projects, it's imperative that two completely different types of readers are accounted for: humans and browsers. Writing minimal markup makes it easier for developers to read and understand in a code editor. Valid markup is easier for browsers to process.

We test our markup against the [W3C validator](https://validator.w3.org/) to ensure that it is well formed and provides a fairly consistent experience across browsers.


### Optimize Readability
At WisdmLabs, we often work with large codebases. As such, it's important to optimize markup for human readability. This allows developers to quickly rotate in and out of projects, eases onboarding processes, and improves code maintainability.

Always use tabs for indentation. Doing this allows developers to set their editor preferences for tab width.

When mixing PHP and HTML together, indent PHP blocks to match the surrounding HTML code. Closing PHP blocks should match the same indentation level as the opening block. Similarly, keep PHP blocks to a minimum inside markup. Doing this turns the PHP blocks into a type of tag themselves. Use colon syntax for PHP loops and conditionals so that it's easier to see when a certain loop ends within the block of markup.

#### Examples

Bad:

```php
<ul>
<?php
foreach( $things as $thing ) {
  echo '<li>' . esc_html( $thing ) . '</li>';
}
?>
</ul>
```

Good:

```php
<ul>
    <?php foreach( $things as $thing ) : ?>
        <li><?php echo esc_html( $thing ); ?></li>
    <?php endforeach; ?>
</ul>
```

### Declaring the Proper Doctype
For all new projects we use HTML5 with the following doctype: ```<!DOCTYPE html>```

### Lowercase Tags
Although HTML is not case sensitive, using lowercase tags is our preferred pattern. Again, we're emphasizing readability and consistency.

#### Examples

Bad:

```html
<DIV class="featured-image"></DIV>
```
Good:

```html
<div class="featured-image"></div>
```

### Avoid Unnecessary Presentational Markup
As part of our mission to write clean, semantic markup, avoid writing unnecessary presentational markup. Markup should always dictate what the content is, and CSS should dictate how the content looks. Mixing these two concerns makes maintaining code more difficult.

By using Sass, we're able to better extend our classes within our CSS, allowing us to easily separate concerns between markup and styling. For example, we can ```@extend``` or ```@include``` our grid column sizes as well as media queries to modify the behavior at different sizes so that styles live separately from markup.

This is not to say that multiple classes on an element are unacceptable. Contextual modifier classes are certainly acceptable and encouraged.

#### Examples
Bad:

```html
<div class="col-lg-6 col-md-6 col-sm-9 col-xs-12 featured-image"></div>
```
Good:

```html
<nav class="primary-nav"></nav>
<nav class="primary-nav open"></nav>
```

### Schema.org Markup
[Schema.org](https://schema.org) is the result of collaboration between Google, Bing, Yandex, and Yahoo! to provide the information their search engines need to understand content and provide the best search results possible. Adding Schema.org data to your HTML provides search engines with structured data they can use to improve the way pages display in search results.

For example, if you've ever searched for a restaurant and found that it had star reviews in its search results, this is a product of Schema.org and rich snippets.

Schema.org data is intended to tell the search engines what your data *means*, not just what it says.

To this end, we use Schema.org data where relevant and reasonable to ensure that our clients have the best search visibility that we can provide.

Schema.org data can be provided in two forms: "microdata" markup added to a page's structure or a JSON-LD format. Google prefers developers adopt JSON-LD, which isolates the data provided for search engines from the markup meant for user agents. Even though the JSON-LD spec allows linking to data in an external file, search engines currently only parse JSON-LD data when it appears within a `<script type="application/ld+json">` tag, as shown below.

Schema.org markup should be validated against the [Google Structured Data Testing Tool](https://search.google.com/structured-data/testing-tool/u/0/).

For examples of Schema markup on components, check out the [WisdmLabs WordPress Component Library](https://WisdmLabs.github.io/wp-component-library/)

<h2 id="html5-structural-elements" class="anchor-heading">HTML5 Structural Elements {% include Util/top %}</h2>
HTML5 structural elements allow us to create a more semantic and descriptive codebase and are used in all of our projects. Instead of using ```<div>```s for everything, we can use HTML5 elements like ```<header>```, ```<footer>```, and ```<article>```. They work the same way, in that they're all block level elements, but improve readability and thus maintainability.

There are a few common pitfalls to avoid with HTML structural elements. Not everything is a ```<section>```. The element represents a generic document or application section and should contain a heading.

Another misconception is that the ```<figure>``` element can only be used for images. In fact, it can be used to mark up diagrams, SVG charts, photos, and code samples.

Finally, not all groups of links on a page need to be in a nav element. The ```<nav>``` element is primarily intended for sections that consist of major navigation blocks.

### Examples

Bad:

```html
<section id="wrapper">
    <header>
        <h1>Header content</h1>
    </header>
    <section id="main">
        <!-- Main content -->
    </section>
    <section id="secondary">
        <!-- Secondary content -->
    </section>
</section>
```

Good:

```html
<div class="wrapper">
    <header>
        <h1>My super duper page</h1>
        <!-- Header content -->
    </header>
    <main role="main">
        <!-- Page content -->
    </main>
    <aside role="complementary">
        <!-- Secondary content -->
    </aside>
</div>
```

### Type attribute on script and style elements is not necessary in HTML5
Since all browsers expect scripts to be JavaScript and styles to be CSS, you don't need to include a type attribute. While it isn't really a mistake, it's a best practice to avoid this pattern.

Bad example:

```html
<link type="text/css" rel="stylesheet" href="css/style.css" />
<script type="text/javascript" src="script/scripts.js"></script>
```
Good example:

```html
<link rel="stylesheet" href="css/style.css">
<script src="script/scripts.js"></script>
```

<h2 id="classes-ids" class="anchor-heading">Classes &amp; IDs {% include Util/top %}</h2>
In order to create more maintainable projects, developers should use classes for CSS and IDs for JavaScript. Separating concerns allows markup to be more flexible without risking breaking both styles and any JavaScript that may be attached to the element on which someone is working.

When using JavaScript to target specific elements in your markup, prefix the ID of the element that is being targeted with `js-`. This indicates the element is being targeted by JavaScript for your future self as well as other developers that may work on the project.

Example:

```html
<nav id="js-primary-menu" class="primary-menu"></nav>
```

### Avoid using inline styles or JavaScript
These are not easily maintainable and can be easily lost or cause unforeseen conflicts.

<h2 id="accessibility" class="anchor-heading">Accessibility {% include Util/top %}</h2>
It's important that our clients and their customers are able to use the products that we create for them. Accessibility means creating a web that is accessible to all people: those with disabilities and those without. We must think about people with visual, auditory, physical, speech, cognitive and neurological disabilities and ensure that we deliver the best experience we possibly can to everyone. Accessibility best practices also make content more easily digestible by search engines. Increasingly, basic accessibility can even be a legal requirement. In all cases, an accessible web benefits everyone.

### Accessibility Standards
At a minimum, all WisdmLabs projects should pass [WCAG 2.1 Level A Standards](https://www.w3.org/WAI/intro/wcag). A baseline compliance goal of Level A is due to [WCAG guideline 1.4.3](https://www.w3.org/WAI/WCAG20/quickref/#visual-audio-contrast-contrast) which requires a minimum contrast ratio on text and images, as WisdmLabs does not always control the design of a project. 

For design projects and projects with a global marketplace (companies with entities outside the US), Level AA should be the baseline goal. The accessibility level is elevated for global markets to properly comply with [EU Functional Accessibility Requirements](http://mandate376.standards.eu/standard/technical-requirements/#9), which aligns closely with WCAG 2.0 Level AA. Having direct access to the designer also allows for greater accessibility standards to be achieved.

While [Section 508](https://www.section508.gov/) is the US standard, following the guidance of WCAG 2.0 will help a project pass Section 508 and also maintain a consistent internal standard. If a project specifically requires Section 508, additional confirmation testing can be done.

### States and Properties
ARIA also allows us to describe certain inherent properties of elements, as well as their various states. Imagine you've designed a site where the main content area is split into three tabs. When the user first visits the site, the first tab will be the primary one, but how does a screen reader get to the second tab? How does it know which tab is active? How does it know which element is a tab in the first place?

ARIA attributes can be added dynamically with JavaScript to help add context to your content. Thinking about the tabbed content example, it might look something like this:

```html
<ul role="tablist">
    <li role="presentation">
        <a href="#first-tab" role="tab" aria-selected="true" id="tab-panel-1">Panel 1</a>
    </li>
    <li role="presentation">
        <a href="#second-tab" role="tab" aria-selected="false" id="tab-panel-2">Panel 2</a>
    </li>
</ul>

<div role="tabpanel" aria-hidden="false" aria-labelledby="tab-panel-1">
    <h2 id="first-tab">Tab Panel Heading</h2>
</div>

<div role="tabpanel" aria-hidden="true" aria-labelledby="tab-panel-2">
    <h2 id="second-tab">Second Tab Panel Heading</h2>
</div>
```

You can see how effortless it is to make our tabbed interface accessible to screen readers. Be sure to add visibility attributes like ```aria-hidden``` with JavaScript. If it is added manually in HTML and JavaScript doesn't load, the content will be completely removed from screen readers.

### Accessible Forms
Forms are one of the biggest challenges when it comes to accessibility. Fortunately, there are a few key things that we can do to ensure they meet accessibility standards:

Each form field should have its own ```<label>```. The label element, along with the ```for``` attribute, can help explicitly associate a label to a form element adding readability screen readers and assistive technology.

Form elements should also be logically grouped using the ```<fieldset>``` element. Grouped form elements can be helpful for users who depend on screen readers or those with cognitive disabilities.

Finally, we should ensure that all interactive elements are keyboard navigable, providing easy use for people with vision or mobility disabilities (or those not able to use a mouse). In general, the tab order should be dictated by a logical source order of elements. If you feel the need to change the tab order of certain elements, it likely indicates that you should rework the markup to flow in a logical order or have a conversation with the designer about updates that can be made to the layout to improve accessibility.

### Bypass Blocks

[Bypass blocks](https://www.w3.org/TR/UNDERSTANDING-WCAG20/navigation-mechanisms-skip.html), are HTML flags within in a document that allow users that rely on screen readers, keyboard navigation or other assistive technologies to _bypass_ certain page elements or _skip_ to a specific section of a page with ease. They most often manifest themselves in the form of [skip links](https://webaim.org/techniques/skipnav/) and [ARIA landmark roles](https://www.w3.org/WAI/GL/wiki/Using_ARIA_landmarks_to_identify_regions_of_a_page)

#### Skip Links
Skip links are ideally placed immediately inside of the `<body>` tag so that are discovered and announced as early as possible.

While these links are often used to skip to a page's main content section they can link to different sections of the page if necessary and several links can be added if multiple areas of interest are in the page.

An example of what a skip link might look like in a template file:

```html
<a class="skip-link screen-reader-text" href="#main">
  <?php esc_html_e( 'Skip to content', 'my-domain' ); ?>
</a>
```

Skip links make use of CSS to hide them from sighted users while keeping them accessible for screen readers. Usually the styles are attached to a `screen-reader-text` class of some kind. This CSS is used to position the links off the screen then use `:focus` styles to make the link visible for sighted keyboard users.

Due to some browsers [not moving keyboard focus when they move visual focus](https://axesslab.com/skip-links/), it is essential to also enhance this feature with JavaScript. The popular Underscores starter theme [comes bundled with a good option](https://github.com/Automattic/_s/blob/master/js/skip-link-focus-fix.js) that can be used as a starting point.

#### ARIA Landmark Roles

ARIA is a descriptive layer on top of HTML to be used by screen readers. It has no effect on how elements are displayed or behave in browsers. We use these ARIA Landmark Roles (banner, navigation, main, etc.) to provide a better experience to users with disabilities. Landmark role are another type of bypass block. Screen readers can see these as major document regions and navigate to them directly without having to parse through all the content in between.

Landmark roles should be used with skip links (not instead of), so we can be sure and offer support for older assitive technology platforms that may not yet support the specification.

Example:

```html
<header role="banner">
  { Site Banner }
  <nav role="navigation">{ Main Navigation }</nav>
</header>
<main role="main">{ Main content }</main>
<footer role="contentinfo">{ Site Footer }</header>
```

### Automated Testing
In most cases, maintaining baseline accessibility requirements for a project can be an automated process. While we can't test everything, and we still need some manual testing, there are certain tools that allow us to keep our finger on the pulse of a project's accessibility compliance.

Automating accessibility tests is easy with a tool like [pa11y](https://github.com/pa11y/pa11y), which is a command line tool that runs [HTML Code Sniffer](http://squizlabs.github.io/HTML_CodeSniffer/) over a URL.

It is easily installed through npm: ```npm install pa11y --save-dev``` and can be adding into a ```package.json``` file as a separate npm script as to not collide with other build processes that may be running on a project:

```
"scripts": {
    "pa11y": "pa11y --ignore notice https://projectname.test"
},
```

Running this process allows the engineer to be alerted if a code-level or design change violates the project's accessibility standards.

### Manual Testing
Automated testing will often only get you so far; that is why we also recommend getting a human's eye on the accessibility in a project and executing manual tests alongside any automation. This process is largely done by an engineer reviewing the interface in a browser or screen reader and involves running your project through all of the WCAG guidelines at the compliance level that is applicable to your specific project (A, AA, or AAA). The [WCAG Quickref](https://www.w3.org/WAI/WCAG20/quickref/) is a great place to see all these guidelines in one place. Internally, we also have a spreadsheet template to help manage this process.

Manual accessibility testing should be run in conjunction with automated testing to help identify all the potential areas of improvement on a project as well as resolve false-positives that may appear during the automated testing process. Tests should be run on a reasonable sample size of templates to help produce the most comprehensive analysis possible - preferably the same templates used in the automated testing process. 

Combining automated and manual testing practices allows WisdmLabs to maintain a high level of compliance on all projects and it is critical to the work we do.

<h2 id="progressive-enhancement" class="anchor-heading">Progressive Enhancement {% include Util/top %}</h2>
Progressive enhancement means building a website that is robust, fault tolerant, and accessible. Progressive enhancement begins with a baseline experience and builds out from there, adding features for browsers that support them. It does not require us to select supported browsers or revert to table-based layouts. Baselines for browser and device support are set on a project-by-project basis.

At WisdmLabs, we employ progressive enhancement to ensure that the sites we build for our clients are accessible to as many users as possible. For example, browser support for SVG has not yet reached 100%. When using SVG you should always provide a fallback such as a PNG image for browsers that do not support vector graphics.

### Polyfills
When writing markup that does not have wide browser support, using polyfills can help bring that functionality to those older browsers. Providing support for older browsers is incredibly important to the business objectives of our clients. In an effort to prevent code bloat, we only provide polyfills for features that are functionally critical to a site.

### Feature Detection
At WisdmLabs, the concept of feature detection is used to test browser support for new features that do not yet have full support across the board. The concept of feature detection is to test if a feature is supported by the browser and if not supported, conditionality run code to provide a similar experience with browsers that do support the feature. While popular [feature detection libraries](https://modernizr.com/) exist, there are [feature detection techniques](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Cross_browser_testing/Feature_detection#JavaScript) for JavaScript and [@supports](https://developer.mozilla.org/en-US/docs/Web/CSS/@supports) at-rule for CSS that can be utilized.
