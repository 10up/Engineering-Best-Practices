<h2 id="philosophy" class="anchor-heading">Philosophy {% include Util/link_anchor anchor="philosophy" %}</h2>
At 10up, we aim to create the best possible experience for both our clients and their customers; not for the sake of using cool, bleeding edge technologies that may not have widespread browser support. Our markup embodies this approach.

Markup is intended to define the structure and outline of a document and to offer semantic structure for the document's contents. Markup should not define the look and feel of the content on the page beyond the most basic structural concepts such as headers, paragraphs, and lists.

At 10up, we employ progressive enhancement to ensure that the sites we build for our clients are accessible to as many users as possible.

Progressive enhancement means building a website that is robust, fault tolerant, and accessible. Progressive enhancement begins with a baseline experience and builds out from there, adding features for browsers that support them. It does not require us to select supported browsers or revert to table-based layouts. Baselines for browser and device support are set on a project-by-project basis.

<h2 id="accessibility" class="anchor-heading">Accessibility {% include Util/link_anchor anchor="accessibility" %} {% include Util/top %}</h2>
It's important that our clients and their customers are able to use the products that we create for them. Accessibility means creating a web that is accessible to all people: those with disabilities and those without. We must think about people with visual, auditory, physical, speech, cognitive and neurological disabilities and ensure that we deliver the best experience we possibly can to everyone. Accessibility best practices also make content more easily digestible by search engines. Increasingly, basic accessibility can even be a legal requirement. In all cases, an accessible web benefits everyone.

### Accessibility Standards
At a minimum, all 10up projects should pass [WCAG 2.1 Level A Standards](https://www.w3.org/WAI/intro/wcag). A baseline compliance goal of Level A is due to [WCAG guideline 1.4.3](https://www.w3.org/WAI/WCAG20/quickref/#visual-audio-contrast-contrast) which requires a minimum contrast ratio on text and images, as 10up does not always control the design of a project.

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

Each form field should have its own ```<label>```. The label element, along with the ```for``` attribute, can help explicitly associate a label to a form element adding readability for screen readers and assistive technology.

Form elements should also be logically grouped using the ```<fieldset>``` element. Grouped form elements can be helpful for users who depend on screen readers or those with cognitive disabilities.

Finally, we should ensure that all interactive elements are keyboard navigable, providing easy use for people with vision or mobility disabilities (or those not able to use a mouse). In general, the tab order should be dictated by a logical source order of elements. If you feel the need to change the tab order of certain elements, it likely indicates that you should rework the markup to flow in a logical order or have a conversation with the designer about updates that can be made to the layout to improve accessibility.

### Bypass Blocks

[Bypass blocks](https://www.w3.org/TR/UNDERSTANDING-WCAG20/navigation-mechanisms-skip.html) are HTML flags within a document that allow users that rely on screen readers, keyboard navigation or other assistive technologies to _bypass_ certain page elements or _skip_ to a specific section of a page with ease. They most often manifest themselves in the form of [skip links](https://webaim.org/techniques/skipnav/) and [ARIA landmark roles](https://www.w3.org/WAI/GL/wiki/Using_ARIA_landmarks_to_identify_regions_of_a_page)

#### Skip Links
Skip links are ideally placed immediately inside of the `<body>` tag so that they are discovered and announced as early as possible.

While these links are often used to skip to a page's main content section they can link to different sections of the page if necessary and several links can be added if multiple areas of interest are in the page.

An example of what a skip link might look like in a template file:

```html
<a class="skip-link screen-reader-text" href="#main">
  <?php esc_html_e( 'Skip to content', 'my-domain' ); ?>
</a>
```

Skip links make use of CSS to hide them from sighted users while keeping them accessible for screen readers. Usually the styles are attached to a `screen-reader-text` class of some kind. This CSS is used to position the links off the screen then use `:focus` styles to make the link visible for sighted keyboard users.

Due to some browsers [not moving keyboard focus when they move visual focus](https://axesslab.com/skip-links/), it is essential to also enhance this feature with JavaScript. The popular Underscores starter theme [came bundled with a good option](https://github.com/Automattic/_s/blob/cf4410cb1fe413324ed1efc9f5ba094423fdd86c/js/skip-link-focus-fix.js) that can be used as a starting point if you need to support browsers with this issue.

#### ARIA Landmark Roles

ARIA is a descriptive layer on top of HTML to be used by screen readers. It has no effect on how elements are displayed or behave in browsers. We use these ARIA Landmark Roles (banner, navigation, main, etc.) to provide a better experience to users with disabilities. Landmark role are another type of bypass block. Screen readers can see these as major document regions and navigate to them directly without having to parse through all the content in between.

Landmark roles should be used with skip links (not instead of), so we can be sure and offer support for older assistive technology platforms that may not yet support the specification.

Example:

```html
<header role="banner">
  { Site Banner }
  <nav role="navigation">{ Main Navigation }</nav>
</header>
<main role="main">{ Main content }</main>
<footer role="contentinfo">{ Site Footer }</footer>
```

### Automated Testing
In most cases, maintaining baseline accessibility requirements for a project can be an automated process. While we can't test everything, and we still need some manual testing, there are certain tools that allow us to keep our finger on the pulse of a project's accessibility compliance.

Automating accessibility tests is easy with a tool like [pa11y](https://github.com/pa11y/pa11y), which is a command line tool that runs [HTML Code Sniffer](http://squizlabs.github.io/HTML_CodeSniffer/) over a URL.

It is easily installed through npm: ```npm install pa11y --save-dev``` and can be added into a ```package.json``` file as a separate npm script as to not collide with other build processes that may be running on a project:

```js
"scripts": {
    "pa11y": "pa11y --ignore notice https://projectname.test"
},
```

Running this process allows the engineer to be alerted if a code-level or design change violates the project's accessibility standards.

### Manual Testing
Automated testing will often only get you so far; that is why we also recommend getting a human's eye on the accessibility in a project and executing manual tests alongside any automation. This process is largely done by an engineer reviewing the interface in a browser or screen reader and involves running your project through all of the WCAG guidelines at the compliance level that is applicable to your specific project (A, AA, or AAA). The [WCAG Quickref](https://www.w3.org/WAI/WCAG20/quickref/) is a great place to see all these guidelines in one place. Internally, we also have a spreadsheet template to help manage this process.

Manual accessibility testing should be run in conjunction with automated testing to help identify all the potential areas of improvement on a project as well as resolve false-positives that may appear during the automated testing process. Tests should be run on a reasonable sample size of templates to help produce the most comprehensive analysis possible - preferably the same templates used in the automated testing process.

Combining automated and manual testing practices allows 10up to maintain a high level of compliance on all projects and it is critical to the work we do.

<h2 id="structure" class="anchor-heading">Structure {% include Util/link_anchor anchor="structure" %}</h2>

At 10up, we pride ourselves in writing clean, semantic markup. Semantic markup can be defined as: "the use of HTML markup to reinforce the semantics, or meaning, of the information in web pages rather than merely to define it's presentation or look. Semantic HTML is processed by traditional web browsers as well as by many other user agents. CSS is used to suggest its presentation to human users" (definition from Wikipedia -[https://en.wikipedia.org/wiki/Semantic_HTML](https://en.wikipedia.org/wiki/Semantic_HTML)).

Semantic elements are elements with clearly defined meaning to both the browser and the developer. Elements like ```<header>```, ```<nav>```, ```<footer>```, or ```<article>``` do a much better job of explaining the content that is contained within the element than ```<span>``` or ```<div>```. This does not mean that we do not use ```<div>```s in our markup, only that we prefer the right tool (or in this case semantic element) for the job.

### Minimal &amp; Valid
Websites should be written using the least amount of markup that accomplishes the goal. In the interest of engineering maintainable projects, it's imperative that two completely different types of readers are accounted for: humans and browsers. Writing minimal markup makes it easier for developers to read and understand in a code editor. Valid markup is easier for browsers to process.

We test our markup against the [W3C validator](https://validator.w3.org/) to ensure that it is well formed and provides a fairly consistent experience across browsers.

### Optimize Readability
At 10up, we often work with large codebases. As such, it's important to optimize markup for human readability. This allows developers to quickly rotate in and out of projects, eases onboarding processes, and improves code maintainability.

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

### Avoid Unnecessary Presentational Markup
As part of our mission to write clean, semantic markup, avoid writing unnecessary presentational markup. Markup should always dictate what the content is, and CSS should dictate how the content looks. Mixing these two concerns makes maintaining code more difficult.

This is not to say that multiple classes on an element are unacceptable. Contextual modifier classes are certainly acceptable and encouraged.

### Schema.org Markup
[Schema.org](https://schema.org) is the result of collaboration between Google, Bing, Yandex, and Yahoo! to provide the information their search engines need to understand content and provide the best search results possible. Adding Schema.org data to your HTML provides search engines with structured data they can use to improve the way pages display in search results.

For example, if you've ever searched for a restaurant and found that it had star reviews in its search results, this is a product of Schema.org and rich snippets.

Schema.org data is intended to tell the search engines what your data *means*, not just what it says.

To this end, we use Schema.org data where relevant and reasonable to ensure that our clients have the best search visibility that we can provide.

Schema.org data can be provided in two forms: "microdata" markup added to a page's structure or a JSON-LD format. Google prefers developers adopt JSON-LD, which isolates the data provided for search engines from the markup meant for user agents. Even though the JSON-LD spec allows linking to data in an external file, search engines currently only parse JSON-LD data when it appears within a `<script type="application/ld+json">` tag, as shown below.

Schema.org markup should be validated against the [Google Structured Data Testing Tool](https://search.google.com/structured-data/testing-tool/u/0/).

For examples of Schema markup on components, check out the [10up WordPress Component Library](https://10up.github.io/wp-component-library/)

### Classes &amp; IDs
In order to create more maintainable projects, developers should use classes for CSS and IDs for JavaScript. Separating concerns allows markup to be more flexible without risking breaking both styles and any JavaScript that may be attached to the element on which someone is working.

When using JavaScript to target specific elements in your markup, prefix the ID of the element that is being targeted with `js-`. This indicates the element is being targeted by JavaScript for your future self as well as other developers that may work on the project.

<h2 id="polyfills" class="anchor-heading">Feature Detection and Polyfills {% include Util/link_anchor anchor="polyfills" %} {% include Util/top %}</h2>

### Polyfills
When writing markup that does not have wide browser support, using polyfills can help bring that functionality to those older browsers. Providing support for older browsers is incredibly important to the business objectives of our clients. In an effort to prevent code bloat, we only provide polyfills for features that are functionally critical to a site.

### Feature Detection
At 10up, the concept of feature detection is used to test browser support for new features that do not yet have full support across the board. The concept of feature detection is to test if a feature is supported by the browser and if not supported, conditionality run code to provide a similar experience with browsers that do support the feature. While popular [feature detection libraries](https://modernizr.com/) exist, there are [feature detection techniques](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Cross_browser_testing/Feature_detection#JavaScript) for JavaScript and [@supports](https://developer.mozilla.org/en-US/docs/Web/CSS/@supports) at-rule for CSS that can be utilized.

<h2 id="media" class="anchor-heading">Media {% include Util/link_anchor anchor="media" %}</h2>
If accessibility starts with HTML, media is how we make it come alive. Creating accessible media is not only the responsibility of an editorial team, but it is our responsibility as engineers to ensure the systems we put in place promote and support the creation of accessible media. It can generally be put into three buckets: images, audio, and video. When looking for direction in these areas we turn to the rules laid out by the [Web Content Accessibility Guidelines (WCAG)](https://www.w3.org/WAI/standards-guidelines/wcag/).

To read more about any of the guidelines outlined in this section, please visit the [WCAG quickref document](https://www.w3.org/WAI/WCAG21/quickref/). Some of the more aggressive guidelines in Level AAA are not mentioned here. Be sure to check with your project lead about the accessibility compliance level you need to follow.

### Images
Images are the most common form of media we encounter in our day to day work. WCAG guidelines pertaining to images are: [1.1.1 Non-text content](https://www.w3.org/WAI/WCAG21/quickref/#non-text-content) and [1.4.4 Images of text](https://www.w3.org/WAI/WCAG21/quickref/#images-of-text). Following these two rules will ensure that our images always have alternative text and any time text is represented in an image there is always a purely text-based version of it available for users of assistive technology.

### Audio &amp; Video
Between audio and video, we certainly deal with video more often, but there are some WCAG guidelines that encompass both, such as: [1.2.2 Audio/Video-only](https://www.w3.org/WAI/WCAG21/quickref/#audio-only-and-video-only-prerecorded) and [1.2.3 Audio Descriptions or Media Alternative](https://www.w3.org/WAI/WCAG21/quickref/#audio-description-prerecorded). Both these guidelines address the creation of text-based versions of the media being presented to a user. This typically comes in the form of an audio track on a video, or a transcript outputted on the page somewhere. As an aside, outputting a transcript will help the content get indexed by search engines, rather than just having the content inside a media element (audio/video)

### Audio
Audio is an important part of the work we do; making that content accessible to all users is extremely valuable. Guideline [1.4.1 Audio Control](https://www.w3.org/WAI/WCAG21/quickref/#audio-control) is related to autoplaying audio. The general rule is: don't autoplay audio. However, if you do, and that audio is playing for more than three seconds, 1.4.1 states that either a mechanism must be available to pause or stop the audio, or a mechanism must be available to control audio volume independently from the overall system volume level. This is important for any user with an auditory disorder.

### Video
When putting video on the Web (that contains dialog), [guideline 1.2.2](https://www.w3.org/WAI/WCAG21/quickref/#captions-prerecorded) states that captions must be present, without exception. While we can't always control the content that's placed on a site, we can be sure to guide clients towards a situation for compliance by suggesting transcription services. Other than alternative text, dealing with captions is the most common media accessibility issue you'll likely have to deal with.

<h2 id="svg" class="anchor-heading">SVG {% include Util/link_anchor anchor="svg" %}</h2>
<abbr title="Scaleable Vector Graphic">SVG</abbr> has become a prevalent means for displaying rich vector graphics. <abbr>SVG</abbr> images are great for graphics with well-defined lines and simple color palettes that can be defined algorithmically, e.g. logos, iconography, and illustrations. Here are a few known benefits of SVG:

* __Scalability__ - They look great on retina displays and at any size, i.e. they're resolution independent.
* __File Size__ - Small file size and compresses well.
* __Styling__ - Manipulate fill, stroke, and even animate.

Be mindful that SVGs have potential limitations as well:

* Adding unvetted <abbr>SVG</abbr> graphics to a page has the potential to introduce a security vulnerability. This is why WordPress does not allow uploading of <abbr>SVG</abbr> by default. Read: [<abbr>SVG</abbr> uploads in WordPress (the Inconvenient Truth)](https://bjornjohansen.no/svg-in-wordpress) for more information.
* SVG is __not__ ideal for photographic images or images with complex visual data. In this case, raster formats (JPG, PNG, GIF) will be a better choice.
* Raster images should _not_ be converted to <abbr>SVG</abbr>. It will likely result in a raster image being embedded within the SVG document, which will not provide the same affordances (i.e. <abbr>CSS</abbr> manipulation) as a genuine <abbr>SVG</abbr>. For further reading on vector vs. raster formats, and when to use each: [Adding vector graphics to the Web](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Adding_vector_graphics_to_the_Web).

### <abbr>SVG</abbr> Sprites

Combining <abbr>SVG</abbr> images in a single file (usually called `svg-defs.svg`) has the benefit of helping limit <abbr title="HyperText Transfer Protocol">HTTP</abbr> requests within a document that contains multiple icons. An <abbr>SVG</abbr> sprite file can be embedded  within a document and referenced within the template source with a `<use>` element. The creation of this icon system should be automated through your build process. Read [Icon Systems with SVG Sprites](https://css-tricks.com/svg-sprites-use-better-icon-fonts/) for more information.

### SVG embedded in HTML

When placing an <abbr>SVG</abbr> in markup (i.e. inline) be sure to use the following guidelines:

* If the <abbr>SVG</abbr> is purely **decorative**:
    * An empty `alt=""` can be used: `<img alt="">`, or
	* Use <abbr title="Accessible Rich Internet Applications">ARIA</abbr> attributes to hide the element from assistive technologies: `<svg aria-hidden="true">`
* If the <abbr>SVG</abbr> is **meaningful** then use `<title>` and possibly even `<desc>` or `aria-label` to describe the graphic. Also, be sure to add an `id` to each element, and appropriate <abbr>ARIA</abbr> to overcome a known bug in [Chrome](https://bugs.chromium.org/p/chromium/issues/detail?id=231654&q=SVG%20%20title%20attribute&colspec=ID%20Pri%20M%20Stars%20ReleaseBlock%20Component%20Status%20Owner%20Summary%20OS%20Modified) and [Firefox](https://bugzilla.mozilla.org/show_bug.cgi?id=1151648).

	```html
	<!-- role="img" to exclude image from being traversed by certain browsers w/ group role -->
	<svg role="img" aria-labelledby="uniqueTitleID uniqueDescID">
		<title id="uniqueTitleID">The Title</title>
		<desc id="uniqueDescID">Description goes here...</desc>
	</svg>
	```

* Use `aria-label` if the SVG is linked and has no supporting text.

	```html
	<a href="http://twitter.com/10up" aria-label="Follow 10up on Twitter">
		<svg><use xlink:href="#icon-twitter"></use></svg>
	</a>
	```

* Use [media queries to provide fallbacks for Windows and High Contrast Mode](https://css-tricks.com/accessible-svgs/#article-header-id-20).


### Optimization

Many tools for creating SVG are notorious for including unnecessary markup. We recommend running all <abbr>SVG</abbr> through [SVGO(MG)](https://jakearchibald.github.io/svgomg/) or using tooling, like [gulp-svgmin](https://github.com/ben-eb/gulp-svgmin)

### Further reading:
* [<abbr>SVG</abbr> Tutorial](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial) - MDN web docs
* [An Overview of SVG Sprite Creation Techniques](https://24ways.org/2014/an-overview-of-svg-sprite-creation-techniques/)
* [Using ARIA to enhance <abbr>SVG</abbr> accessibility](https://developer.paciellogroup.com/blog/2013/12/using-aria-enhance-svg-accessibility/) - The Paciello Group
* [Accessible <abbr>SVG</abbr> Icons with Inline Sprites](https://www.24a11y.com/2018/accessible-svg-icons-with-inline-sprites/) 24 Accessibility
* [Accessible <abbr>SVG</abbr> test page](https://weboverhauls.github.io/demos/svg/)
* [Creating Accessible SVGs](https://www.deque.com/blog/creating-accessible-svgs/) Deque.com
* [Accessible SVGs](https://css-tricks.com/accessible-svgs/) - CSSTricks.com
