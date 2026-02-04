<h2 id="philosophy" class="anchor-heading">Philosophy {% include Util/link_anchor anchor="philosophy" %}</h2>

At 10up, we value content and the experience users will have reading it. We write CSS with this in mind and don't sacrifice our clients' most important assets over the latest, shiniest, half-supported CSS features just for the sake of using them. CSS should help enhance content, not bury it under "cool" distractions.

Our websites are built mobile first, using performant CSS. Well-structured CSS yields maintainability and better collaboration which ultimately yields better client experiences.

Below are our suggested best practices for writing CSS at 10up.

<h2 id="established-system" class="anchor-heading">Follow an Established System First {% include Util/link_anchor anchor="established-system" %}</h2>

There are countless ways to organize your CSS styles. From naming conventions to structuring files, there’s no single "right" way to do it. What’s important is understanding and respecting the system that’s already in place.

* **Assume intent.** Always operate under the assumption that existing patterns or conventions were created for a reason. Stick to the existing conventions, even if they feel unfamiliar or inefficient at first glance—dig deeper to understand the context. Continuity is critical for maintainability and teamwork.  
* **Learn before you suggest.** When you join a project, take the time to understand how the styles are organized and why they're structured that way. Avoid making snap judgments or introducing changes before fully grasping the system.  
* **When in doubt, align with technical leadership.** If you are unsure about patterns or systems to adhere to, follow the guidance and recommendations of a project's technical leadership (where feasible). 

Only propose changes if the current convention is genuinely problematic, e.g., if it’s inconsistent, hard to scale, or causes errors. When you suggest a change, be ready to explain why the new approach is better and how it solves a specific problem.

This approach helps avoid duplication—why have two things that do the same job? It’s inefficient and creates unnecessary confusion. Beyond that, following established patterns shows respect for your team’s work and fosters a healthy, collaborative relationship. Consistency in the codebase reflects a consistent and unified team.

<h2 id="document-system" class="anchor-heading">Establish and Document the System {% include Util/link_anchor anchor="document-system" %}</h2>

When you start a new codebase, pause before writing components and choose a CSS methodology—such as ITCSS, BEM, or a utility-first approach—that fits the project’s size, maintenance horizon, and team expertise. Committing to a structured methodology early establishes clear naming rules, predictable specificity, and sensible file organization. These guardrails ease onboarding, minimize refactors, and save both time and budget over the life of the project.

If you opt to design a custom architecture, capture every key choice: folder layout, naming conventions, tooling, and any deviations from common patterns. A short explanation of why each decision was made helps future contributors understand the system quickly and avoids guesswork.

**Note:** Keep this record where engineers will look first—typically in a /decisions/ directory inside the repository's setup or onboarding documentation. Follow your project's standard documentation format so the notes remain consistent, searchable, and easy to maintain.

<h2 id="content-agnostic" class="anchor-heading">Assume You Know Nothing About the Content {% include Util/link_anchor anchor="content-agnostic" %}</h2>

When building components, always start with the mindset that you have no control over the content they’ll handle. Even if the client or designer specifies certain limits, assume those constraints could change—or be ignored entirely.

Content is unpredictable. You might not know how long a title will be, how many items a navigation menu will have, or the length of an excerpt in a card. Design decisions made today can quickly be overturned tomorrow when new requirements come in.

Prepare for edge cases. Your components must be resilient and robust enough to handle all reasonable variations, including unexpected ones. If you don’t account for these possibilities, it could lead to broken layouts, unreadable text, or poor user experiences.

**Useful resources:**

- [Defensive CSS](https://defensivecss.dev/)

### Stress Test Your Components

When building a component, test it against extreme content scenarios. For example:

- A navigation menu with twenty items instead of five.
- A card designed to display an image but rendered without one.
- A card meant for a single-line title, but the title wraps to three or more lines.
- A card title that consists of a single word.
- An excerpt that is three hundred characters long, or completely empty.

The goal is to make these situations work. They may not look ideal, but they should remain usable and accessible.

Designing flexible, content-agnostic components makes your work more resilient over time. It reduces the need for constant adjustments and helps protect layouts from breaking when content does not match the original assumptions. In practice, requirements tend to change as a project moves forward.

<h2 id="minimal-styles" class="anchor-heading">Write Only the Styles You Need, Don't Do Too Much {% include Util/link_anchor anchor="minimal-styles" %}</h2>

When writing CSS, stick to the styles you need and avoid overcomplicating. For example, centering a container horizontally often involves a common snippet:

```css
.container {
  max-width: 48rem;
  margin: 0 auto; /* ⚠️ Avoid this */
}
```

While this centering approach achieves the goal, it also zeroes out the top and bottom margins, which may not be intentional and will have unwanted impact in the cascade. Instead, only set the margin you need:

```css
.container {
  max-width: 48rem;
  margin-inline: auto; /* ✅ Do this instead */
}
```

This approach, using logical properties like `margin-inline`, maintains the desired horizontal centering without unnecessary side effects. Avoid shorthands that set multiple properties when only one is needed.

Another example is background styling: 

```css
.button--secondary {
  background: var(--color--dark-gray);
}
```

Using background shorthand like the above implicitly sets many background properties, which can unintentionally override defaults. Instead, specify only the needed properties:

```css
.button--secondary {
  background-color: var(--color--dark-gray);
}
```

The same principle applies to other shorthand properties, such as `border`, `transform`, `transition`, `font`, and others.

Finally, be cautious with broad declarations that affect more elements than intended. For instance, adding an underline animation to links:

```css
a {
  text-decoration: none;
  background-image: linear-gradient(currentColor, currentColor);
  background-position: 0% 100%;
  background-repeat: no-repeat;
  background-size: 100% 2px;
  transition: background-size 0.3s;
}
```

Adding a global style like this can unintentionally affect other links that don’t require this underline treatment (image links, site logo, etc.). Instead, there are two recommended methods to handle similar styles. First, you can target elements (i.e. links) like this more precisely:

```css
.entry-content :is(h1, h2, h3, h4, h5, h6, p, li) > a {
  /* styles here */
}
```

This selector precisely targets only links that are direct children of text content elements within `.entry-content`, avoiding the side effects of the overly broad `a` selector. The [`:is()` pseudo-class](https://developer.mozilla.org/en-US/docs/Web/CSS/:is) keeps this selector concise by matching any of the listed elements without needing to repeat the entire selector chain for each element type.

Second, you can use a utility class.

```css
.has-animated-underline {
  /* styles here */
}
```

These solutions ensure only the intended elements are styled and avoid unintended side effects. Keep your CSS clean and purposeful by applying styles selectively and avoiding overly broad or shorthand declarations.

<h2 id="mobile-first" class="anchor-heading">Mobile-First by Default {% include Util/link_anchor anchor="mobile-first" %}</h2>

Designing with a mobile-first approach is essential because most users access websites from their mobile devices. Starting with the mobile layout ensures the core content and functionality are optimized for smaller screens, providing a better user experience. Once the mobile layout is solid, it’s easier to scale up for larger screens, ensuring a consistent and responsive design across all devices, rather than doing it the other way around.

This doesn't mean we must *design* for mobile devices first chronologically (although it is a viable approach), but rather that mobile devices get enough attention and are not an afterthought. This approach also helps prioritize essential features and content, making the site faster and more efficient.

### What Does It Mean in Practice?

As a front-end engineer, it's crucial to be present at every design planning meeting. Your job is *not* just to determine whether the designs can be done in CSS but whether they *should* be done. Your input ensures that the designs are not only visually appealing but also can be implemented for mobile devices in an efficient way.

Always advocate for creating mobile designs if they are not already included and for simplicity in implementation.

### Keep an Eye Out for Common Pitfalls

When reviewing designs, look for common pitfalls like the ones below:

* Different aspect ratios of images on mobile vs. desktop. If approved, this leads to complicated back-end logic and art direction.  
* Different order of elements on desktop vs mobile. This can usually be done with CSS Grid or Flexbox, but there are accessibility implications like focusing order that should be taken into account. This can usually be avoided.  
* Designs that require different markup on mobile vs. desktop. This often leads to bloated CSS, unnecessary JS to handle markup changes, or duplicated markup. All of this can usually be avoided.

If you see a way to simplify the implementation, always voice it. Suggest adjustments that will make the system leaner and more maintainable.

### Style the Project as If Desktop Doesn’t Exist First

Style the project as if Desktop doesn’t exist first and then expand or override rules for the desktop.

With the capabilities of modern CSS it is usually best to reach for media queries last and use features like auto-rows in CSS Grid or functions like clamp() to create layouts that are mobile and desktop-friendly.

Allowing for this flexibility helps handle the “in-between-breakpoint” layouts nicely.

### Scrolling Is Okay

Just like books have pages and readers know they need to flip them to move forward, users know they need to scroll to get further on a webpage. Keep this in mind when you see designs like:

* Lists of links that look like a select dropdown on mobile and turn into a list on desktop.  
* Grids on desktop that turn into a carousel on mobile.

There are cases where such layout patterns are necessary. Not all select dropdowns or carousels are bad, but in most cases, this is unnecessary complication. Simple scrolling usually works just fine and is more intuitive than more complicated UI patterns.

Needless to say, implementing such changes between viewports takes more time and can pose accessibility implications.

**Useful resources:**

- [There Is No Fold](https://www.lukew.com/ff/entry.asp?1946)

<h2 id="solid-defaults" class="anchor-heading">Set Solid Defaults {% include Util/link_anchor anchor="solid-defaults" %}</h2>

When building a robust and scalable front-end architecture, setting good default styles is an essential first step. Establishing a CSS foundation ensures consistency across browsers and provides a solid base for further styling. This foundation can be achieved using one of three primary approaches:

1. **CSS Reset:** A reset removes virtually all default styles applied by browsers, leveling the playing field by eliminating discrepancies. While this approach offers the cleanest slate, it also removes potentially useful styles, requiring more effort to rebuild a cohesive design system.  
2. **CSS Normalize:** A normalize CSS file (i.e. [normalize.css](https://necolas.github.io/normalize.css/)) focuses on addressing inconsistencies between browsers while retaining most of their default styles. This approach minimizes the need for excessive rework while still providing a reliable base.  
3. **Hybrid (or Custom) Approach:** Many projects adopt a blend of resets and normalization, coupled with project-specific global styles, to balance control and practicality. For example, resetting some elements like margins and paddings but setting global defaults for others, (following ITCSS architecture) such as lists and forms.

### The Importance of Global Rules

Global rules play a critical role in setting consistent behavior across your entire application. These rules can prevent costly refactoring and unexpected bugs as your project evolves. One key example is setting the `box-sizing` property globally:

```css
*,
*::before,
*::after {
  box-sizing: border-box;
}

:where(body) {
  margin: 0;
}
```

By applying `box-sizing: border-box`, you ensure that padding and border widths are included in the element's total width and height calculations. This eliminates common layout issues and simplifies sizing calculations, reducing developer frustration and the likelihood of design inconsistencies.

It is very easy to set up at the beginning of a project and very hard and expensive to fix when the project is live and has hundreds (or in some cases thousands) of pages and many components.

**Important:** Make this decision at the start of your project—don't proceed without addressing it. Either set `box-sizing: border-box` manually as shown above, or verify that your chosen CSS reset or normalize library already includes it. This small upfront decision prevents significant technical debt later.

### Foundational Styles for HTML Elements

A well-crafted CSS foundation includes thoughtful defaults for HTML elements, such as headings, paragraphs, and lists. Avoid setting specific styles, like `text-align: center`, on elements that are likely to be used in various contexts. For example:

**Headings:** Define consistent font sizes, weights, and spacing for `<h1>` through `<h6>` elements to create a harmonious typography hierarchy that cascades effectively throughout your project.

```css
:where(h1) {
  /* styles here */
}

:where(h2) {
  /* styles here */
}

/* And so on for other heading levels */
```

**Lists:** Ensure that unordered and ordered lists have adequate styling by default.

```css
:where(ul, ol, dl) {
  /* styles here */
}
```

These are just a few base examples. Foundational styles should be applied to all elements used in the project. Typically, this is the “elements” level in the ITCSS methodology.

### Avoiding Overly Opinionated Defaults

While foundational styles are crucial, avoid overly opinionated rules that assume specific use cases for elements. For example, setting `text-align: center` or fixed widths on common elements like `<div>` or `<p>` can lead to unnecessary overrides and limited reusability. Foundational styles should support flexibility and adaptability, empowering developers to craft unique designs without battling restrictive defaults.

By thoughtfully implementing and balancing resets, normalization, and custom global styles, you can establish a CSS foundation that fosters maintainability, consistency, and scalability for your project.

<h2 id="inverted-triangle" class="anchor-heading">Follow Inverted Triangle Architecture {% include Util/link_anchor anchor="inverted-triangle" %}</h2>

Inverted Triangle is a methodology for organizing CSS, starting from broad, global styles down to more specific, local rules.

Begin with base styles that affect the entire application:

### Global

* **`@font-face`:** Defines the fonts available throughout the application.

* **Media queries:** When using tools like PostCSS, `@custom-media` rules should be placed here for global breakpoints.

* **CSS Custom Properties:** Also known as variables. When placed in :root, they provide access to all components across the application.

* **Mixins:** If using PostCSS, global mixins should also be defined at this level.

* **Defaults:** Set application-wide defaults, such as box-sizing, global outline behavior, and other foundational styles. Keep this section minimal, as there typically aren't many styles applied at this level.

### Elements

This layer targets raw HTML elements (tags), without using classes, IDs, or other specific selectors. The purpose of the Elements level is to establish foundational styles for elements to be used within components later on.

Below are some examples of styles at this level:

```css
:where(h1) {
  color: var(--color--heading);
  font-family: var(--font--family--heading);
  font-size: var(--font--size--heading-1);
  font-weight: var(--font--weight--heading);
  line-height: var(--font--line-height--heading-1);
  margin-block: 0;
}
```

Key details to note:

* **`:where` pseudo-class:** Ensures zero specificity for these styles, making it easier to apply other styles.

* **CSS Custom Properties:** These variables, defined at the global level, keep the styles consistent and easy to maintain.

* **Margin reset:** The margin is set to zero to remove default browser margins. You can handle multiple headings in one go with `:where(h1, h2, h3...) { margin-block: 0 }`.

Avoid adding styles that are too opinionated at the base level. For example, setting `text-align: center` on the heading in the previous example can cause issues. Even if most headings are center-aligned, there will likely be cases where you need a left- or right-aligned heading. This forces you to override the style in all components where center alignment isn’t needed, bloating the CSS and adding mental overhead.

Be cautious about which styles you place at this level. Only include styles that should apply to all elements in 99.9% of cases. Removing base-level styles once a project is live—especially if thousands of pages depend on them—can introduce regressions.

### Components

The Component layer is where styles are applied to reusable UI elements. These are more complex than base-level styles and use classes to ensure component-level specificity.

#### Key Guidelines

* **Reusability:** Focus on creating modular, reusable components. Always consider how the component will respond to:

  * Changes in viewport width.

  * Varying content. For example, if you're styling a card with a title that fits nicely on one line in the design, think about how the card will react to a very long title, or if there's no title at all.

* **Inheritance from Base:** Components should take advantage of the solid foundation provided by base styles. When base-level styles are set up correctly, you minimize the need to redefine styles. Usually, you'll only need to adjust specific properties like colors or spacing at the component level.

* **Avoid Using Margins on Components:** Baking margins into reusable components creates spacing that's difficult to override in different contexts. Instead, create spacing using techniques like the lobotomized owl selector (`* + *`) or the `gap` property on parent containers. We'll cover these approaches in detail later in this document.

* **Encapsulation:** Component styles should be scoped and encapsulated to avoid affecting other components. Use methodologies like BEM or CUBE to ensure your styles remain modular and isolated.

* **Leverage Variables:** Use globally defined variables for properties like colors and spacing. This avoids magic numbers and ensures visual consistency across your app.

* **Responsiveness:** Components should be fully responsive, adapting effortlessly to different container sizes and screen widths.

* **Component-Specific Animations:** If a component requires a unique animation that won't be reused elsewhere, define the `@keyframes` alongside the component styles. This keeps related code together and makes it easier to maintain or remove the component later.

### Utilities

Utility classes provide quick, reusable styling solutions for common, single-purpose tasks. They allow you to apply styles without the need for creating new components.

#### Key Guidelines

* **Single Responsibility:** Each utility class should only do one thing. For example, the is-style-h1 class should only apply the styles required to make the text appear as heading level 1 and do nothing else.

* **Specificity Level:** Utility classes sit at the top of the inverted triangle architecture, so they can have higher specificity than base styles and components. In practice, they usually have the same level of specificity as components, because of that, they should be applied after the component class.

* **Consistency:** Like global variables, utility classes help maintain consistency throughout the app. By standardizing common patterns like text alignment, padding, or display properties, you reduce the risk of divergent styles across components.

* **Reusable Animations:** Place reusable `@keyframes` animations in the utilities layer when they're used across multiple components (e.g., fade-in, slide-up, pulse). This promotes consistency and reduces duplication across your codebase.

**Useful resources:**

- [The Inverted Triangle Architecture: how to manage large CSS Projects](https://www.freecodecamp.org/news/managing-large-s-css-projects-using-the-inverted-triangle-architecture-3c03e4b1e6df/)
- [ITCSS × Skillshare](https://csswizardry.com/2018/11/itcss-and-skillshare/) - Harry Roberts' official collaboration on ITCSS methodology

<h2 id="accessibility" class="anchor-heading">Always Keep Accessibility in Mind {% include Util/link_anchor anchor="accessibility" %}</h2>

### Keyboard Navigation

Make sure all interactive elements are accessible via the keyboard. Test that users can navigate through the interface using the Tab key and activate actions with Enter or Space. Avoid creating elements that require a mouse or touch to work.

### Color Contrast

Ensure there’s enough contrast between text and its background. Use tools to check for WCAG compliance. Aim for a contrast ratio of at least 4.5:1 for normal text and 3:1 for larger text. Avoid relying on color alone to convey information.

### Focus

Properly manage focus states. Use :focus-visible styles to make focused elements visible and distinct. Don’t trap focus in modal dialogs or dropdowns without providing a clear way to exit. Reset focus logically when users interact with dynamic content, such as moving to a new page.

### Zoom and Reflow

Your site must support 400% zoom without loss of content or functionality. When a user views your site on a 1280px wide viewport and zooms to 400%, the page should reflow to behave like a 320px viewport. This ensures users who need magnification can still access all features and content.

Key requirements:

* Text must scale to at least 200% of its original size.
* Content should reflow without requiring horizontal scrolling.
* All functionality must remain accessible and usable.
* Sticky headers should not dominate the viewport—ensure they occupy a reasonable portion of the screen at high zoom levels.

Use responsive design techniques with relative units (rem, em, %) rather than fixed pixel values, and test your components at various zoom levels during development. For detailed guidance, see [WCAG 2.2 Understanding Reflow](https://www.w3.org/WAI/WCAG22/Understanding/reflow.html).

### RTL and Logical Properties

Support right-to-left (RTL) languages by using CSS logical properties instead of physical ones where it makes sense. Logical properties use direction-agnostic terms (`inline` and `block`) that automatically adapt to the text direction, making RTL support automatic.

Instead of physical properties like `margin-left`, `padding-right`, or `text-align: left`, use logical equivalents:

```css
.element {
  margin-inline-start: 1rem;  /* instead of margin-left */
  padding-inline: 1rem;       /* instead of padding-left/right */
  text-align: start;           /* instead of text-align: left */
}
```

Set the `dir` attribute on the `<html>` element or specific containers to enable RTL rendering. Test your layouts by toggling `dir="rtl"` to ensure they work correctly in both directions.

**Useful resources:**

- [MDN: Logical Properties and Values](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Logical_Properties)
- [RTL Styling 101](https://rtlstyling.com/)

### Advocate for Accessible Design Patterns

Promote the adoption of design patterns that inherently prevent accessibility issues. Examples include:

* Avoid placing text directly over images unless sufficient contrast or a background overlay is provided to ensure readability.  
* Use native HTML `<select>` elements for dropdowns instead of creating custom solutions or using frameworks. Native elements are inherently accessible and offer consistent behavior across platforms.  
* When custom components are necessary, replicate the behavior of native elements. For instance, custom modals should support full keyboard navigation and include options to close them using standard shortcuts.  
* Design forms with clear and descriptive error messages. Pair these messages with ARIA roles or properties to make them accessible to screen readers.

<h2 id="low-specificity" class="anchor-heading">Keep Specificity Extremely Low {% include Util/link_anchor anchor="low-specificity" %}</h2>

Maintaining low specificity in your CSS is essential for creating scalable, maintainable, and predictable stylesheets. High specificity can make it difficult to override styles, leading to a cascade that is hard to manage and debug. By keeping specificity low, you ensure that your styles remain flexible and easy to adapt as your project evolves.

Aim for a maximum specificity of `0,1,0` to `0,2,1`. Avoid combining tag selectors with classes unless necessary—use `.button` instead of `a.button`, and `.nav-item` instead of `ul.nav li.nav-item`. In limited cases, selectors like `.component .utility-class a` may reach `0,2,1`, but exceeding this threshold requires serious justification.

**Tools for checking specificity:**

- [Specificity Calculator](https://specificity.keegan.st/) - A helpful tool for visualizing and calculating CSS specificity.
- **stylelint rule:** Enforce specificity limits in your projects using the [`selector-max-specificity`](https://stylelint.io/user-guide/rules/selector-max-specificity/) rule. 

### Use `:where()` for Bare Elements

Utilize the `:where()` pseudo-class when styling bare elements to avoid increasing specificity. Unlike other selectors, `:where()` doesn't contribute to specificity, making it easier to override styles when needed and ensuring a cleaner cascade hierarchy. This allows you to apply styles without affecting how CSS rules are prioritized and inherited, keeping the order of styles predictable and easier to manage. For example:

```css
:where(h1, h2, h3, h4, h5, h6) {
  margin-block: 0;
}
```

**Useful resources:**

- [`:where()` on MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/:where) - Comprehensive documentation on specificity impacts and browser support

### Avoid Excessive Nesting

Limit the depth of nesting in your CSS selectors. Two levels of nesting are acceptable, and three should only be used when absolutely necessary. Excessive nesting can make CSS harder to read and maintain. It also increases specificity unnecessarily, which complicates overriding styles and debugging. Over-nesting complicates maintenance and increases specificity unnecessarily.

It’s okay to nest pseudo classes that represent state, for example:

```css
/* block */
.button {

  /* ✅ state inside the block is fine */
  &:hover {
    /* styles here */
  }
}

/* ✅ element and modifier stay flat */
.button__icon {
  /* styles here */
}

.button--primary {
  /* styles here */
}
```

It's not necessary to nest elements or modifiers:

```css
/* block */
.button {

  /* state inside the block is fine */
  &:hover {
    /* styles here */
  }

  /* ❌ element must not be nested inside the block */
  & .button__icon {
    /* styles here */
  }

	/* ❌ modifier must not be nested inside the block */
  &.button--primary {
    /* styles here */
  }
}
```

### Avoid IDs

Refrain from using IDs for styling purposes. IDs have high specificity, which makes them difficult to override and maintain. Instead, use classes for consistent and reusable styling. If you must target an element by its ID in CSS, consider using an attribute selector like `[id="drawer-trigger"]` instead of `#drawer-trigger`—this provides the same uniqueness without the specificity cost.

### Avoid !important

Reserve `!important` for truly exceptional cases. Overusing `!important` disrupts the cascade and makes debugging more difficult. Focus on writing clean, organized selectors instead of relying on this property to enforce styles.

<h2 id="no-margins-components" class="anchor-heading">Do Not Use Margins on Reusable Components {% include Util/link_anchor anchor="no-margins-components" %}</h2>

Margins might look like one of the easiest CSS properties to manage, but they’re also a common source of layout headaches if not handled carefully.

* Avoid margins on reusable components. Margins can lock components into specific contexts, making them harder to use in different layouts. If you add margins to a reusable component, you’re creating assumptions about where and how it will be placed.  
* Design components with isolation in mind. Treat every component as if you have no idea what its future container will look like. Focus on the component's internal spacing and leave external spacing to the parent or container that uses it.

### Example

Let’s say you have a Card component. Avoid doing this:

```css
.card {
  margin-block: 1.5rem; /* ⚠️ Avoid this */
}
```

Instead, define the margin outside of the component:

```css
/* Context-specific spacing */
.card-grid {
  display: grid;
  grid-template-columns: ...
  row-gap: 1.5rem; /* ✅ Do this instead */
}
```

This achieves the same result, but the Card can now be reused without disrupting layouts where the margin isn’t needed.

**Note:** It doesn't have to be a grid. The key idea is to set margins at the "element" level, ensuring the reusable component—like card-grid in the example—controls only what happens inside it, not outside.

<h2 id="one-direction-margins" class="anchor-heading">Apply Margins in One Direction {% include Util/link_anchor anchor="one-direction-margins" %}</h2>

When applying margins, stick to using them in a single direction. This approach promotes consistency, simplifies debugging, and makes layouts easier to manage.

* **Consistency across the codebase.** By standardizing margin usage, you create a predictable structure. This consistency makes it easier for others (and future you) to understand and work with the code.  
* **Simpler debugging.** Troubleshooting layout issues becomes much easier when margins are applied in only one direction. You don't have to chase down conflicting styles or figure out which element's margins are responsible for extra spacing.  
* **Avoid collapsing margins.** Margins applied in both directions can lead to confusing margin-collapsing behavior in CSS. Sticking to one direction eliminates this issue entirely, making the layout behavior more predictable and easier to control.  
* **Why "up" is preferred.** Applying margins upwards (e.g., margin-top) is particularly effective because it works seamlessly with the [lobotomized owl selector](https://alistapart.com/article/axiomatic-css-and-lobotomized-owls/) (`* + *`). This selector targets all adjacent siblings and is perfect for applying consistent spacing between elements without extra markup.
* **Proportional spacing.** When combined with `em` units, the lobotomized owl unlocks proportional spacing—`.component > * + * { margin-top: 1.5em; }` automatically gives headings more margin than paragraphs since `em` scales with each element's font-size.

<h2 id="responsiveness" class="anchor-heading">Responsiveness and Media Queries {% include Util/link_anchor anchor="responsiveness" %}</h2>

Creating responsive designs is essential, but the approach you take can make a big difference in your code's maintainability and flexibility. Media queries are a powerful tool, but they shouldn’t always be your first choice.

* **Reach for media queries last.** Instead of relying heavily on media queries to adjust styles, focus on building layouts and components that adapt naturally to different screen sizes. Media queries should be a fallback for cases where intrinsic solutions won’t work.  
* **Leverage clamp().** Use the clamp() function to create [fluid, responsive values](https://www.sitepoint.com/fluid-typography-css-clamp-function/) for properties like font sizes, spacing, and widths. It allows you to define a minimum, preferred, and maximum value, so elements scale dynamically without needing media queries.  
* **Use intrinsic layouts with CSS Grid.** Grid layouts are inherently responsive and let you define flexible areas that adjust automatically to available space. Pair grids with techniques like minmax() and auto-fit for dynamic behavior without extra breakpoints.

<h2 id="naming" class="anchor-heading">Naming Things {% include Util/link_anchor anchor="naming" %}</h2>

Clear, consistent naming makes your CSS maintainable, readable, and scalable. Good naming conventions help developers quickly understand what each part of the code does, leading to fewer mistakes and easier updates. Here are practical recommendations for naming CSS elements:

### Classes

* Use descriptive, semantic names (e.g., .user-profile, .card-header).  
* Prefer lowercase with hyphens (kebab-case).  
* Keep names reusable and avoid overly specific context.

### IDs

* Use sparingly and not for styling, (e.g. for use with anchors and in-page links)  
* Names should clearly communicate the unique purpose.  
* Prefer camelCase (e.g., `#mainNavigation`).
* For JavaScript-specific functionality, consider using a `js-` prefix with kebab-case (e.g., `#js-main-navigation`) to clearly indicate the element is targeted by JavaScript code.

### Custom Properties (CSS Variables)

* Name according to usage rather than appearance (e.g., `--primary-color`, `--spacing-large`).  
* Use hyphenated lowercase consistently.  
* Keep them semantic to represent meaning and intent.
* Avoid excessive nesting or chaining of CSS variables (e.g., mapping a color to a UI name to another variable). Deep abstractions create unnecessary layers, increase bundle size, and reduce performance. Keep token hierarchies reasonably flat—aim for 1-2 levels of abstraction rather than 3+ levels.

A common use case for CSS Custom Properties is design tokens. Naming tokens is crucial and delicate—well-named tokens ensure consistency, ease of understanding, and scalability.

* When naming design tokens, use clear, meaningful names that reflect hierarchical relationships. In most projects, it makes sense to separate tokens into two categories: `primitive` and `semantic`. Primitive tokens describe the values directly, like `color-red-100` and `font-weight-bold`, while semantic tokens describe the application of primitive tokens, like `color-background-default` or `typography-body-font-family`.  
* Avoid overly abstract, compact, or vague names; clarity and predictability are key. `button` is better than `btn`.  
* Consistently apply naming patterns to help users anticipate token structures.  

**Useful resources:**

- [Naming Tokens in Design Systems](https://medium.com/eightshapes-llc/naming-tokens-in-design-systems-9e86c7444676#08b2)

### Animations (@keyframes)

* Use clear action-based names (e.g., fade-in, slide-up).  
* Maintain short, intuitive names indicating the animation's behavior.

### Grid Template Areas and Lines

* Area names should reflect their content purpose (e.g., header, sidebar, content).  
* Grid line names should be descriptive (e.g., main-start, footer-end).  
* Stick with concise, easily recognizable terms.

<h2 id="new-features" class="anchor-heading">New CSS Features {% include Util/link_anchor anchor="new-features" %}</h2>

Browsers keep evolving, and CSS is always introducing new features. But adopting them too soon can cause issues for older or niche browsers. Here’s how we evaluate and adopt modern CSS.

When introducing a new feature, think about the experience a user will get if the feature is not available. CSS features, when not supported, are ignored by browsers. Always think about what the effect is for an unsupported browser. 

### 1. Check Browser Compatibility

In 2023, Google introduced Baseline to help developers determine whether certain features or APIs are safe to use in production. This tool aids in understanding the stability and support of web features across the most recent two versions of major browsers: Safari, Firefox, Chrome, and Edge.

* Use [Can I Use](https://caniuse.com/) (backed by Google Baseline) to see which browsers support a feature.  
* Google Baseline classifies support:

  * **Newly available:** Interoperable across all major browsers.  
  * **Widely available:** Feature has been interoperable for at least 30 months.  
  * **Limited availability:** Not yet in Baseline; some browsers lack support.

### 2. Provide Fallbacks

Place a widely supported declaration first, then the modern one. Old browsers ignore unknown properties, so they naturally fall back.

```css
.element {
  height: 100vh;    /* widely supported unit */
  height: 100dvh;   /* newer unit */
}
```

If the browser doesn’t know `100dvh`, it sticks to `100vh`. No breakage, just a simpler layout.

### 3. Use @supports

`@supports` is a native CSS feature-detection mechanism.

```css
.site {
  min-height: 100vh;
}

@supports (min-height: 100dvh) {
  .site {
    min-height: 100dvh;
  }
}
```

Or reverse it with not:

```css
.site {
  min-height: 100dvh;
}

/* remove when dvh is fully supported */
@supports not (min-height: 100dvh) {
  .site {
    min-height: 100vh;
  }
}
```

Add comments like `/* remove when dvh is fully supported */` above fallback code. This makes it easy to search and remove outdated fallbacks when browser support improves.

### 4. Consider Polyfills

* Polyfills bring modern features to older browsers via JS.  
* They add dependencies, increase bundle size, and require maintenance.  
* If the feature can degrade gracefully, skipping a polyfill is often better.

### 5. Use Automated Tooling

* PostCSS (with postcss-preset-env) can convert cutting-edge CSS into more compatible code.  
* Inspect how it transforms your code. Some transformations, like `@layer`, can bloat your CSS with hacks like `:not(#\#)` selectors—that's why we avoid `@layer` on large projects that require support for older browsers.
* Decide if that overhead is worth it.

### 6. Decide How Soon to Adopt

* Foundational features (like `@layer`) can break large parts of a layout if unsupported. Check analytics to see if your user base can handle it.  
* Enhancements (like `text-wrap: balance`) degrade gracefully. If unsupported, the browser ignores it and uses the existing styling.

In short, weigh your users’ browser usage and the criticality of the feature. Rely on Google Baseline, fallback strategies, and safe coding practices. Add polyfills or build tools only if the benefit outweighs the cost. That’s how you use modern CSS without leaving anyone behind.

**Useful resources:**

- [https://www.joshwcomeau.com/css/browser-support/](https://www.joshwcomeau.com/css/browser-support/)  
- [https://www.youtube.com/watch?v=WIvQLSPcvtA](https://www.youtube.com/watch?v=WIvQLSPcvtA)
