### Philosophy
At 10up, we aim to create the best possible experience for both our clients and their customers; not for the sake of using cool, bleeding edge technologies that may not have widespread browser support. Our markup embodies this approach.

#### Principles
Markup is intended to define the structure and outline of a document and to offer semantic structure for the document's contents. Markup should not define the look and feel of the content on the page beyond the most basic structural concepts such as headers, paragraphs, and lists.

At 10up, our projects are often large and ongoing. As such, it's imperative that we engineer projects to be maintainable. From a markup perspective, we do this by adhering to the following principles:

#### Semantic
At 10up, we pride ourselves in writing clean, semantic markup. Semantic markup can be defined as: "the use of HTML markup to reinforce the semantics, or meaning, of the information in web pages rather than merely to define it's presentation or look. Semantic HTML is processed by traditional web browsers as well as by many other user agents. CSS is used to suggest its presentation to human users" (definition from Wikipedia -[http://en.wikipedia.org/wiki/Semantic_HTML](http://en.wikipedia.org/wiki/Semantic_HTML)).

Semantic elements are elements with clearly defined meaning to both the browser and the developer. Elements like ```<header>```, ```<nav>```, ```<footer>```, or ```<article>``` do a much better job of explaining the content that is contained within the element than ```<span>``` or ```<div>```. This does not mean that we do not use ```<div>```'s in our markup, only that we prefer the right tool (or in this case semantic element) for the job.


#### Minimal &amp; Valid
Websites should be written using the least amount of markup that accomplishes the goal. In the interest of engineering maintainable projects, it's imperative that two completely different types of readers are accounted for: humans and browsers. Writing minimal markup makes it easier for developers to read and understand in a code editor. Valid markup is easier for browsers to process.

We test our markup against the [W3C validator](http://validator.w3.org/) to ensure that it is well formed and provides a fairly consistent experience across browsers.


#### Optimize Readability
At 10up, we often work with large codebases. As such, it's important to optimize markup for human readability. This allows developers to quickly rotate in and out of projects, eases onboarding processes, and improves code maintainability.

Always use tabs for indentation. Doing this allows developers to set their editor preferences for tab width.

When mixing PHP and HTML together, indent PHP blocks to match the surrounding HTML code. Closing PHP blocks should match the same indentation level as the opening block. Similarly, keep PHP blocks to a minimum inside markup. Doing this turns the PHP blocks into a type of tag themselves. Use colon syntax for PHP loops and conditionals so that it's easier to see when a certain loop ends within the block of markup.

##### Examples

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

#### Declaring the Proper Doctype
For all new projects we use HTML5 with the following doctype: ```<!DOCTYPE html>```

#### Lowercase Tags
Although HTML is not case sensitive, using lowercase tags is our preferred pattern. Again, we're emphasizing readability and consistency.

##### Examples

Bad:

```html
<DIV class="featured-image"></DIV>
```
Good:

```html
<div class="featured-image"></div>
```

#### Avoid Unnecessary Presentational Markup
As part of our mission to write clean, semantic markup, avoid writing unnecessary presentational markup. Markup should always dictate what the content is, and CSS should dictate how the content looks. Mixing these two concerns makes maintaining code more difficult.

By using Sass, we're able to better extend our classes within our CSS, allowing us to easily separate concerns between markup and styling. For example, we can ```@extend``` or ```@include``` our grid column sizes as well as media queries to modify the behavior at different sizes so that styles live separately from markup.

This is not to say that multiple classes on an element are unacceptable. Contextual modifier classes are certainly acceptable and encouraged.

##### Examples
Bad:

```html
<div class="col-lg-6 col-md-6 col-sm-9 col-xs-12 featured-image"></div>
```
Good:

```html
<nav class="primary-nav"></nav>
<nav class="primary-nav open"></nav>
```

#### Schema.org Markup
[Schema.org](http://schema.org) is the result of collaboration between Google, Bing, Yandex, and Yahoo! to provide the information their search engines need to understand content and provide the best search results possible. Adding Schema markup to your HTML provides search engines with structured data they can use to improve the way pages display in search results.

For example, if you've ever searched for a restaurant and found that it had star reviews in its search results, this is a product of Schema.org and rich snippets.

Schema.org markup is intended to tell the search engines what your data *means*, not just what it says.

To this end, we use Schema.org markup where relevant and reasonable to ensure that our clients have the best search visibility that we can provide.

Schema markup should be validated against the [Google Structured Data Testing Tool](https://developers.google.com/structured-data/testing-tool/).

##### Examples

Bad:

```html
<div>
  <div>
    <span>The Catcher in the Rye</span> (
    <a href="http://en.wikipedia.org/wiki/The_Catcher_in_the_Rye">wikipedia</a>)
  </div>
  <span>4 stars</span>
  <b>"A good read."</b>
  <span>
    <span>Bob Smith</span>
  </span>
  <span>Catcher in the Rye is a fun book. It's a good book to read.</span>
</div>
```

Good:

```html
<div itemscope itemtype="http://schema.org/Review">
  <div itemprop="itemReviewed" itemscope itemtype="http://schema.org/Book">
    <span itemprop="name">The Catcher in the Rye</span> (
    <a itemprop="sameAs" href="http://en.wikipedia.org/wiki/The_Catcher_in_the_Rye">wikipedia</a>)
  </div>
  <span itemprop="reviewRating" itemscope itemtype="http://schema.org/Rating">
    <span itemprop="ratingValue">4</span>
  </span> stars -
  <strong>"<span itemprop="name">A good read.</span>"</strong>
  <span itemprop="author" itemscope itemtype="http://schema.org/Person">
    <span itemprop="name">Bob Smith</span>
  </span>
  <span itemprop="reviewBody">Catcher in the Rye is a fun book. It's a good book to read.</span>
</div>
```

<h3 id="html5-structural-elements">HTML5 Structural Elements {% include Util/top %}</h3>
HTML5 structural elements allow us to create a more semantic and descriptive codebase and are used in all of our projects. Instead of using ```<div>```s for everything, we can use HTML5 elements like ```<header>```, ```<footer>```, and ```<article>```. They work the same way, in that they're all block level elements, but improve readability and thus maintainability.

There are a few common pitfalls to avoid with HTML structural elements. Not everything is a ```<section>```. The element represents a generic document or application section and should contain a heading.

Another misconception is that the ```<figure>``` element can only be used for images. In fact, it can be used to mark up diagrams, SVG charts, photos, and code samples.

Finally, not all groups of links on a page need to be in a nav element. The ```<nav>``` element is primarily intended for sections that consist of major navigation blocks.

#### Examples

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

#### Type attribute on script and style elements is not necessary in HTML5
Since all browsers expect scripts to be JavaScript and styles to be CSS, you don't need to include type attribute. While it isn't really a mistake, it's a best practice to avoid this pattern.

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

<h3 id="classes-ids">Classes &amp; IDs {% include Util/top %}</h3>
In order to create more maintainable projects, developers should use classes for CSS and IDs for JavaScript. Separating concerns allows markup to be more flexible without risking breaking both styles and any JavaScript that may be attached to the element on which someone is working.

When using JavaScript to target specific elements in your markup, prefix the ID of the element that is being targeted with `js-`. This indicates the element is being targeted by JavaScript for your future self as well as other developers that may work on the project.

Example:

```html
<nav id="js-primary-menu" class="primary-menu"></nav>
```

#### Avoid using inline styles or JavaScript
These are not easily maintainable and can be easily lost or cause unforeseen conflicts.

<h3 id="accessibility">Accessibility {% include Util/top %}</h3>
It's important that our clients and their customers are able to use the products that we create for them. Accessibility means creating a web that is accessible to all people: those with disabilities and those without. We must think about people with visual, auditory, physical, speech, cognitive and neurological disabilities and ensure that we deliver the best experience we possibly can to everyone. Accessibility best practices also make content more easily digestible by search engines. Increasingly, basic accessibility can even be a legal requirement. In all cases, an accessible web benefits everyone.

At minimum, every 10up project should make use of ARIA Landmark roles, semantic headings, and alt text on images. Compliance with Section 508, or other international accessibility laws and guidelines, may be required depending upon the project.

We draw much of our information from two prominent accessibility guides: [WCAG (Web Content Accessibility Guidelines)](http://www.w3.org/WAI/intro/wcag) and [Section 508](http://www.section508.gov/).

#### ARIA Landmark Roles
ARIA (Assistive Rich Internet Applications) is a spec from the W3C. It was created to improve accessibility of applications by providing extra information to screen readers via HTML attributes. Screen readers can already read HTML, but ARIA can help add context to content and make it easier for screen readers to interact with content.

ARIA is a descriptive layer on top of HTML to be used by screen readers. It has no effect on how elements are displayed or behave in browsers. We use these ARIA Landmark Roles (banner, navigation, main, etc.) to provide a better experience to users with disabilities.

Example:

```html
<header id="masthead" class="site-header" role="banner"></header>
```

#### States and Properties
ARIA also allows us to describe certain inherent properties of elements, as well as their various states. Imagine you've designed a site where the main content area is split into three tabs. When the user first visits the site, the first tab will be the primary one, but how does a screen reader get to the second tab? How does it know which tab is active? How does it know which element is a tab in the first place?

ARIA to the rescue!

ARIA attributes can be added with JavaScript to help dynamically add context to your content. Thinking about the tabbed content example, it might look something like this:

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

You can see how effortless it is to make our tabbed interface accessible to screen readers. All we need to do is add context.

#### Accessible Forms
Forms are one of the biggest areas of failure when it comes to accessibility. Fortunately, there are a few key things that we can do to ensure they meet accessibility standards.

Each form field should have its own ```<label>```. The label tag, along with the ```for``` attribute, can help explicitly associate a label to a form element adding readability to the form element for screen readers.

Form elements should also be logically grouped using the ```<fieldset>``` tag. Grouped form elements can be helpful for people who depend on screen readers or those with cognitive disabilities.

Finally, we should ensure that all interactive elements are keyboard (or tab) navigable, providing easy use for people with vision or mobility disabilities. In general, the tab order should be dictated by a logical source order of elements. If you feel the need to change the tab order of certain elements, it likely indicates that you should rework the markup to flow in a logical order.

Adding ```tabindex``` to elements to force a different tab order can become confusing to users and a maintenance issue to developers if/when they have to make changes to the markup. There are cases, however, when we need to add or remove certain elements from the tab order. In these cases, set ```tabindex="0"``` to allow an element (eg. a ```<div>```) to receive focus in its natural order, or set ```tabindex="-1"``` to skip an element (eg. a modal dialog box).

<h3 id="progressive-enhancement">Progressive Enhancement {% include Util/top %}</h3>
Progressive enhancement means building a website that is robust, fault tolerant, and accessible. Progressive enhancement begins with a baseline experience and builds out from there, adding features for browsers that support them. It does not require us to select supported browsers or revert to table-based layouts. Baselines for browser and device support are set on a project-by-project basis.

At 10up, we employ progressive enhancement to ensure that the sites we build for our clients are accessible to as many users as possible. For example, browser support for SVG has not yet reached 100%. When using SVG you should always provide a fallback such as a PNG image for browsers that do not support vector graphics.

#### Polyfills
When writing markup that does not have wide browser support, using polyfills can help bring that functionality to those older browsers. Providing support for older browsers is incredibly important to the business objectives of our clients. In an effort to prevent code bloat, we only provide polyfills for features that are functionally critical to a site.

#### Modernizr
At 10up, we use Modernizr to test browser support for new features that do not yet have full support across the board. Note that you should never use the Development build of Modernizr on a Production site. Create a custom build of Modernizr that features only the tests that are necessary.

Included in Modernizr is HTML5Shiv. HTML5Shiv is important because HTML5 elements are not natively recognized by IE8 and other older browsers. Thus scripting support for older browsers can be provided with this fairly lightweight JavaScript library.
