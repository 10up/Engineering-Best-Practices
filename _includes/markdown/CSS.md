<h3 id="philosophy">Philosophy</h3>

At 10up, we value content and the experience one will have reading it. We write CSS with this in mind and don't sacrifice our clients' most important assets over the latest, shiniest, half-supported CSS features just for the sake of using them. CSS should help enhance content, not bury it under "cool" distractions.

Our websites are built mobile first, using performant CSS. Well structured CSS yields maintainability and better collaboration which ultimately yields better client experiences.

<h3 id="syntax-formatting">Syntax and Formatting {% include Util/top %}</h3>

Syntax and formatting are keys to a maintainable project. By keeping our code style consistent, we not only help ourselves debug faster but we're also lessening the burden on those who will have to maintain our code (maybe ourselves too!)

#### CSS Syntax

CSS syntax is not strict and will accept a lot of variations, but for the sake of legibility and fast debugging, we follow basic code styles:

* Write one selector per line
* Write one declaration per line
* Closing braces should be on a new line

Avoid:

```css
.class-1, .class-2,
.class-3 {
width: 10px; height: 20px;
color: red; background-color: blue; }
```

Prefer:

```css
.class-1,
.class-2,
.class-3 {
  width: 10px;
  height: 20px;
  color: red;
  background-color: blue;
}
```

* Include one space before the opening brace
* Include one space before the value
* Include one space after each comma-separated values

Avoid:

```css
.class-1,.class-2{
  width:10px;
  box-shadow:0 1px 5px #000,1px 2px 5px #ccc;
}
```

Prefer:

```css
.class-1,
.class-2 {
  width: 10px;
  box-shadow: 0 1px 5px #000, 1px 2px 5px #ccc;
}
```

* Try to use lowercase for all values, except for font names
* Zero values don't need units
* End all declarations with a semi-colon, even the last one, to avoid error
* Use double quotes instead of single quotes

Avoid:

```css
section {
  background-color: #FFFFFF;
  font-family: 'Times New Roman', serif;
  margin: 0px
}
```

Prefer:

```css
section {
  background-color: #fff;
  font-family: "Times New Roman", serif;
  margin: 0;
}
```

If you don't need to set all the values, don't use shorthand notation.

Avoid:

```css
.header-background {
  background: blue;
  margin: 0 0 0 10px;
}
```

Prefer:

```css
.header-background {
  background-color: blue;
  margin-left: 10px;
}
```

#### Declaration ordering

Declarations should be ordered alphabetically or by type (Positioning, Box model, Typography, Visual). Whichever order is chosen, it should be consistent across all files in the project.

Sass ordering:

1. @extend
2. Regular styles (allows overriding extended styles)
3. @include (to visually separate mixins and placeholders) and media queries
4. Nested selectors

#### Nesting in Sass

Sass nesting has changed the lives of many, but like everything in life, abusing good things will ultimately be bad. Nesting makes the code more difficult to read and can create confusion. Too much nesting also adds unnecessary specificity, forcing us to add the same or greater specificity in overrides. We want to avoid selector nesting and overspecificity as much as possible.

**Nesting is required** in the following cases, because it will make the code easier to read:

* pseudo-classes
* pseudo-elements
* component states
* media queries

**Nesting is accepted** in the following cases:

* some coding styles like [RSCSS](https://github.com/rstacruz/rscss)

#### Selectors naming

Selectors should be lowercase, and words should be separated with hyphens. Please avoid camelcase. Underscores are acceptable if they’re being used for [BEM](http://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/) syntax. The naming of selectors should be consistent and describe the functional purpose of the styles they’re applying.

Avoid:

```css
.btnRed {
	background-color: red;
}
```

Prefer:

```css
.btn-warning {
	background-color: red;
}
```

For components that could possibly conflict with plugins or third-party libraries, use vendor prefixes. Don’t use names that can be blocked by adblockers (e.g. “advertisement”). When in doubt, you can check a class name against [this list](https://easylist-downloads.adblockplus.org/easylist.txt) to see if it's likely to be blocked.

<h3 id="documentation">Documentation {% include Util/top %}</h3>

Code documentation serves two purposes: it makes maintenance easier and it makes us stop and think about our code. If the explanation is too complex, maybe the code is overly complex too. Documenting helps keep our code simple and maintainable.

#### Commenting

We follow WordPress official commenting standards. Do not hesitate to be very verbose with your comments, especially when documenting a tricky hack. Use comment blocks to separate the different sections of a partial, and/or to describe what styles the partial covers:

```css
/**
 * Section title
 *
 * Description of section
 */
```

For single selectors or inline comments, use this syntax:

```css
/* Inline comment */
```

Make sure to comment any complex selector or rule you write. For example:

```css
/* Select list item 4 to 8, included */
li:nth-child(n+4):nth-child(-n+8) {
	color: red;
}
```

#### SassDoc

We use [SassDoc](http://sassdoc.com/getting-started/) to generate documentation for variables, functions, mixins and placeholders. If you’ve used PHPDoc, this should look familiar.

Example:

```scss
/// Convert Photoshop tracking value to letter-spacing
///
/// @author Your Name
///
/// @param {Integer} $psvalue - The value should be the same value as in Photoshop, required
///
/// @group helpers
///
/// @example scss - Usage
/// 	.wide-tracking {
///			@include tracking(50);
///		}
///
/// @example css - CSS output
/// 	.wide-tracking {
///			letter-spacing: .05em;
/// 	}
@mixin tracking($psvalue) {
  letter-spacing: $psvalue / 1000 + em;
}
```

Read more at [SassDoc official documentation](http://sassdoc.com/getting-started/).

<h3 id="performance">Performance {% include Util/top %}</h3>

Let's be honest, CSS "speed" and performance is not as important as PHP or JavaScript performance. However, this doesn't mean we should ignore it. A sum of small improvements equals better experience for the user.

Three areas of concern are [network requests](#user-content-network-requests), [CSS specificity](#user-content-css-specificity) and [animation](#user-content-animations) performance.

Performance best practices are not only for the browser experience, but for code maintenance as well.

#### Network Requests

* Limit the number of requests by concatenating css files and encoding sprites and font files to the css file.
* Minify stylesheets
* Use GZIP compression when possible
Automate these tasks with a PHP or/and JavaScript build process.

#### CSS Specificity

Stylesheets should go from less specific rules to highly specific rules. We want our selectors specific enough so that we don't rely on code order, but not too specific so that they can be easily overridden.

For that purpose, **classes** are our preferred selectors: pretty low specificity but high reusability.

Avoid using `!important` at all costs.

Use [efficient selectors](http://csswizardry.com/2011/09/writing-efficient-css-selectors/).

Avoid:

```css
div {
  background: radial-gradient(ellipse at center,  #a90329 0%,#8f0222 44%,#6d0019 100%);
}
```

Overqualified:

```css
 div div header#header div ul.nav-menu li a.black-background {
  background: radial-gradient(ellipse at center,  #a90329 0%,#8f0222 44%,#6d0019 100%);
}
```

#### Inheritance

Fortunately, many CSS properties can be inherited from the parent. Take advantage of inheritance to avoid bloating your stylesheet but keep [specificity](#user-content-css-specificity) in mind.

Avoid:

```css
.sibling-1 {
	font-family: Arial, sans-serif;
}
.sibling-2 {
	font-family: Arial, sans-serif;
}
```

Prefer:

```css
.parent {
	font-family: Arial, sans-serif;
}
```

#### Reusable code

Styles that can be shared, should be shared (aka DRY, Don’t Repeat Yourself). This will make our stylesheets less bloated and prevent the browser from doing the same calculations several times. Make good use of Sass placeholders. (also see [Inheritance](#inheritance))

#### CSS over assets

Don't add an extra asset if a design element can be translated in the browser using CSS only. We value graceful degradation over additional HTTP requests.

Very common examples include gradients and triangles.

#### Animations

It's a common belief that CSS animations are more performant than JavaScript animations. A few articles aimed to set the record straight (linked below).

* If you're only animating simple state changes and need good mobile support, go for CSS (most cases).
* If you need more complex animations, use a JavaScript animation framework or requestAnimationFrame.

Limit your CSS animations to 3D transforms (translate, rotate, scale) and opacity, as those are aided by the GPU and thus smoother. Note that too much reliance on the GPU can also overload it.

Avoid:

```css
#menu li{
  left: 0;
  transition: all 1s ease-in-out;
}
#menu li:hover {
  left: 10px
}
```

Always test animations on a real mobile device loading real assets, to ensure the limited memory environment doesn't tank the site.

Articles worth reading:
* [CSS animations performance: the untold story](http://greensock.com/css-performance)
* [Myth Busting: CSS Animations vs. JavaScript](https://css-tricks.com/myth-busting-css-animations-vs-javascript/)
* [CSS vs. JS Animation: Which is Faster?](http://davidwalsh.name/css-js-animation)
* [Why Moving Elements With Translate() Is Better Than Pos:abs Top/left](http://www.paulirish.com/2012/why-moving-elements-with-translate-is-better-than-posabs-topleft/)
* [CSS vs JavaScript Animations](https://developers.google.com/web/fundamentals/look-and-feel/animations/css-vs-javascript?hl=en)
* [requestAnimationFrame](https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame)

<h3 id="responsive-websites">Responsive websites {% include Util/top %}</h3>

We build our websites mobile first. We do not rely on `respond.js` as it does not work well in certain environments. Instead, we leverage the benefits of Sass to manipulate our breakpoints.

#### Min-width media queries

A responsive website should be built with min-width media queries.  This approach means that our media queries are consistent, readable and minimize selector overrides.

* For most selectors, properties will be added at later breakpoints. This way we can reduce the usage of overrides and resets.
* It targets the least capable browsers first which is philosophically in line with mobile first — a concept we often embrace for our sites
* When media queries consistently "point" in the same direction, it makes it easier to understand and maintain stylesheets.

Avoid mixing min-width and max-width media queries.

#### Breakpoints

Working with Sass, we can take advantages of mixins and avoid having a ton of different breakpoints. Example of a basic media query mixin with a function to check if the breakpoint we want to use has been defined before:

```scss
/// Register devices widths
$devices: (
	mobile-landscape: 480px,
	tablet: 768px,
	tablet-landscape: 1024px,
	laptop: 1280px,
	desktop: 1440px
) !default;

/// Verify that the breakpoint width is listed
///
/// @param {string} $breakpoint - breakpoint name
/// @group mediaqueries
@function get-breakpoint-width($breakpoint) {
	@if map-has-key($devices, $breakpoint) {
		@return map-get($devices, $breakpoint);
	} @else {
		@warn "Breakpoint #{$breakpoint} wasn't found in $devices.";
	}
}

/// Min-width media query
///
/// @param {string} $breakpoint - breakpoint name
/// @group mediaqueries
@mixin at-least($breakpoint) {
	$device-width: get-breakpoint-width($breakpoint);
	@media screen and (min-width: $device-width) {
		@content;
	}
}
```

#### Media queries placement

In Sass files, nest the media query or media query mixin within the selector it modifies. **Do not** create size-based partials (e.g. `_1024px.scss`, `_480px.scss`): it will be frustrating to hunt for a specific selector through all the files when we have to maintain the project. Putting the media query inside the selector will allow developers to immediately see all the different styles applied to an element.

Avoid:

```css
@media only screen and (min-width: 1024px) {
	@import "responsive/1024up";
}
.some-class {
	color: red;
}
.some-other-class {
	color: orange;
}
@media only screen and (min-width: 1024px) {
	.some-class {
		color: blue;
	}
}
```

Prefer:

```css
.some-class {
	color: red;
	@media only screen and (min-width: 1024px) {
		color: blue;
	}
}
.some-other-class {
	color: orange;
}
```

#### IE8 and older browser support

We prefer showing a fixed-width non-responsive desktop version to older IE users rather than showing a mobile version.

* Use a breakpoint mixin to target older browsers (See [sass-mq](https://github.com/sass-mq/sass-mq) and similar).
* Load a different stylesheet for older browsers.

<h3 id="frameworks">Frameworks {% include Util/top %}</h3>

#### Grids

If a simple grid is needed, define and document placeholders and mixins as needed in a _grid.scss partial. For an example of lightweight grid systems, see [Don’t Overthink It Grids](https://css-tricks.com/dont-overthink-it-grids/).

Our preference is not to use a 3rd party grid system. Too often we are faced with a design that isn’t built on a grid or purposefully breaks a loosely defined grid. Even if the designer had a grid in mind, there are often needs that require more creative solutions. For example: fixed-width content areas to accommodate advertising.

Sometimes a more complex grid sytem is warranted and leveraging a 3rd party library will gain some efficiency. However, keep in mind that by adopting a grid system you are forcing all future collaborators on the project to learn this system. For some sites we will consider the use of popular and well supported grid systems, such as [Bourbon Neat](http://neat.bourbon.io/) or [Susy](http://susydocs.oddbird.net/).

#### Resets

As of [August 13th, 2015](http://10up.com/blog/2015/sponsoring-sanitize-css/) 10up has taken stewardship of [sanitize.css](https://github.com/10up/sanitize.css), making it our primary tool for resets. Although we can still consider using [normalize.css](http://necolas.github.io/normalize.css/).

### Further reading {% include Util/top %}

[CSS: Just Try and Do a Good Job](http://css-tricks.com/just-try-and-do-a-good-job/)
