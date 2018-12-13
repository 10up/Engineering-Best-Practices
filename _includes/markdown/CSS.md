<h2 id="philosophy" class="anchor-heading">Philosophy</h2>

At WisdmLabs, we value content and the experience users will have reading it. We write CSS with this in mind and don't sacrifice our clients' most important assets over the latest, shiniest, half-supported CSS features just for the sake of using them. CSS should help enhance content, not bury it under "cool" distractions.

Our websites are built mobile first, using performant CSS. Well-structured CSS yields maintainability and better collaboration which ultimately yields better client experiences.

<h2 id="syntax-formatting" class="anchor-heading">Syntax and Formatting {% include Util/top %}</h2>

Syntax and formatting are keys to a maintainable project. By keeping our code style consistent, we not only help ourselves debug faster but we're also lessening the burden on those who will have to maintain our code (maybe ourselves too!).

### CSS Syntax

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
* End all declarations with a semi-colon, even the last one, to avoid errors
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

### Declaration ordering

Declarations should be ordered alphabetically or by type (Positioning, Box model, Typography, Visual). Whichever order is chosen, it should be consistent across all files in the project.

If you're using Sass, use this ordering:

1. @extend
2. Regular styles (allows overriding extended styles)
3. @include (to visually separate mixins and placeholders) and media queries
4. Nested selectors

### Nesting

Nesting has changed the lives of many, but like everything in life, abusing good things will ultimately be bad. Nesting makes the code more difficult to read and can create confusion. Too much nesting also adds unnecessary specificity, forcing us to add the same or greater specificity in overrides. We want to avoid selector nesting and over-specificity as much as possible.

If you're using PostCSS or Sass **nesting is required** in the following cases, because it will make the code easier to read:

* pseudo-classes
* pseudo-elements
* component states
* media queries

### Selector Naming

Selectors should be lowercase, and words should be separated with hyphens. Please avoid camelcase, but underscores are acceptable if they’re being used for [BEM](https://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/) or another syntax pattern that requires them. The naming of selectors should be consistent and describe the functional purpose of the styles they’re applying.

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

<h2 id="documentation" class="anchor-heading">Documentation {% include Util/top %}</h2>

Code documentation serves two purposes: it makes maintenance easier and it makes us stop and think about our code. If the explanation is too complex, maybe the code is overly complex too. Documenting helps keep our code simple and maintainable.

### Commenting

We follow WordPress official commenting standards. Do not hesitate to be very verbose with your comments, especially when documenting a tricky part of your CSS. Use comment blocks to separate the different sections of a partial, and/or to describe what styles the partial covers:

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

<h2 id="performance" class="anchor-heading">Performance {% include Util/top %}</h2>

Let's be honest, CSS "speed" and performance is not as important as PHP or JavaScript performance. However, this doesn't mean we should ignore it. A sum of small improvements equals better experience for the user.

Three areas of concern are [network requests](#network-requests), [CSS specificity](#css-specificity) and [animation](#animations) performance.

Performance best practices are not only for the browser experience, but for code maintenance as well.

### Network Requests

* Limit the number of requests by concatenating CSS files and encoding sprites and font files to the CSS file.
* Minify stylesheets
* Use GZIP compression when possible
Automate these tasks with a PHP or/and JavaScript build process.

### CSS Specificity

Stylesheets should go from less specific rules to highly specific rules. We want our selectors specific enough so that we don't rely on code order, but not too specific so that they can be easily overridden.

For that purpose, **classes** are our preferred selectors: pretty low specificity but high reusability.

Avoid using `!important` whenever you can.

Use [efficient selectors](https://csswizardry.com/2011/09/writing-efficient-css-selectors/).

Avoid:

```css
 div div header#header div ul.nav-menu li a.black-background {
  background: radial-gradient(ellipse at center,  #a90329 0%,#8f0222 44%,#6d0019 100%);
}
```

### Inheritance

Fortunately, many CSS properties can be inherited from the parent. Take advantage of inheritance to avoid bloating your stylesheet but keep [specificity](#css-specificity) in mind.

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

### Reusable code

Styles that can be shared, should be shared (aka DRY, Don’t Repeat Yourself). This will make our stylesheets less bloated and prevent the browser from doing the same calculations several times. Make good use of Sass placeholders. (also see [Inheritance](#inheritance))

### CSS over assets

Don't add an extra asset if a design element can be translated in the browser using CSS only. We value graceful degradation over additional HTTP requests.

Very common examples include gradients and triangles.

### Animations

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
* [CSS animations performance: the untold story](https://greensock.com/css-performance)
* [Myth Busting: CSS Animations vs. JavaScript](https://css-tricks.com/myth-busting-css-animations-vs-javascript/)
* [CSS vs. JS Animation: Which is Faster?](https://davidwalsh.name/css-js-animation)
* [Why Moving Elements With Translate() Is Better Than Pos:abs Top/left](https://www.paulirish.com/2012/why-moving-elements-with-translate-is-better-than-posabs-topleft/)
* [CSS vs JavaScript Animations](https://developers.google.com/web/fundamentals/look-and-feel/animations/css-vs-javascript?hl=en)
* [requestAnimationFrame](https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame)

<h2 id="responsive-websites" class="anchor-heading">Responsive websites {% include Util/top %}</h2>

We build our websites mobile first. We do not rely on JavaScript libraries such as `respond.js` as it does not work well in certain environments. Instead, we leverage a natural, mobile-first build process and allow sites gracefully degrade.

### Min-width media queries

A responsive website should be built with min-width media queries. This approach means that our media queries are consistent, readable and minimize selector overrides.

* For most selectors, properties will be added at later breakpoints. This way we can reduce the usage of overrides and resets.
* It targets the least capable browsers first which is philosophically in line with mobile first — a concept we often embrace for our sites
* When media queries consistently "point" in the same direction, it makes it easier to understand and maintain stylesheets.

Avoid mixing min-width and max-width media queries.

### Breakpoints

Working with build tools that utilize Sass or PostCSS processing, we can take advantages of reusability and avoid having an unmaintainable number of breakpoints. Using variables and reusable code blocks we can lighten the CSS load and ease maintainability.

### Media queries placement

In your stylesheet files, nest the media query within the component it modifies. **Do not** create size-based partials (e.g. `_1024px.(s)css`, `_480px.(s)css`): it will be frustrating to hunt for a specific selector through all the files when we have to maintain the project. Putting the media query inside the component will allow developers to immediately see all the different styles applied to an element.

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

### IE8 and older browser support

We prefer showing a fixed-width non-responsive desktop version to older IE users rather than showing a mobile version.

* Use a feature detection to target older browsers.
* Load a different stylesheet for older browsers.

<h2 id="frameworks" class="anchor-heading">Frameworks {% include Util/top %}</h2>

### Grids

Our preference is not to use a 3rd party grid system, use your best judgement and keep them simple! All too often we are faced with a design that isn’t built on a grid or purposefully breaks a loosely defined grid. Even if the designer had a grid in mind, there are often needs that require more creative solutions. For example: fixed-width content areas to accommodate advertising.

Sometimes a more complex grid system is warranted and leveraging a 3rd party library will gain some efficiency. However, keep in mind that by adopting a grid system you are forcing all future collaborators on the project to learn this system.

### Resets

[Normalize.css](https://necolas.github.io/normalize.css/) is our primary tool for CSS resets. 

## Further reading {% include Util/top %}

[CSS: Just Try and Do a Good Job](https://css-tricks.com/just-try-and-do-a-good-job/)
