<h2 id="getting-started" class="anchor-heading">Getting Started with Accessibility {% include Util/link_anchor anchor="getting-started" %} {% include Util/top %}</h2>

At Kanopi we aim to meet the requirements for Level AA from the [WCAG 2.1 Guidelines](https://www.w3.org/TR/WCAG21/) while also looking ahead to what standards will be included in the next version.

While the official document is comprehensive and well documented, the [quick reference guide from W3C](https://www.w3.org/WAI/WCAG21/quickref/) is a lot easier to parse, search, and filter, and will be referenced here in this document. It's also [summarized later in this document](#wcag).

---

### Principle 1 - [Perceivable](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview#principle1) 

*   Provide text alternatives for all content that relies on visual context
    *   Menu buttons, close buttons, shopping cart icons, charts, etc.
    *   [More About Links](#links)
    *   [1.1.1 Non-text Content - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview#non-text-content)
*   All image elements must have the  `alt` attribute, no exceptions
    *    `<img src="#" alt />`  and  `<img src="#" alt="" />`  are acceptable.
    *   [More About Images](#images)
    *   [1.1.1 Non-text Content - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview#non-text-content)
*   Videos and audio files require captions or transcripts in order to present a text alternative for that media.
    *   Auto captioning is acceptable.
    *   [More About Video & Audio](#videos)
    *   [1.2.1 Audio-only and Video-only (Prerecorded) - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C121#audio-only-and-video-only-prerecorded)
    *   [1.2.2 Captions (Prerecorded) - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C121#captions-prerecorded)
*   Use semantic HTML wherever possible.
    *   Use HTML5 elements and landmarks
    *   Add ARIA where relationships are unclear
    *   [More About Landmarks](#landmarks)
    *   [More About ARIA](#aria)
    *   [1.2.1 Info and Relationships - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131#info-and-relationships)
*   Organize pages with headings
    *   [More About Headings](#headings)
    *   [1.2.1 Info and Relationships - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131#info-and-relationships)
*   DOM order should match the visual order
    *   Exceptions can be made, but only if the result is not confusing visually or audibly.
    *   [1.3.2 Meaningful sequence - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132#meaningful-sequence)
*   Do not indicate purpose solely with color.
    *   Links must have another visual indicator (icons, underlines, backgrounds, design elements, placement) 
    *   If colors were removed, information should not be lost.
    *   [1.4.1 Use of Color - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132#use-of-color)
*   Text requires a contrast ratio of 4.5:1
    *   Text larger than 24px, or 19-23px that is bold, only need to meet 3:1
    *   Graphic elements (such as icons, checkboxes, etc) need to meet 3:1
    *   [Contrast Checker](https://webaim.org/resources/contrastchecker/)
    *   [1.4.3 Contrast (Minimum) - Level AA](https://www.w3.org/WAI/WCAG21/quickref/#contrast-minimum)
    *   [1.4.11 Non-text Contrast - Level AA](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C332#non-text-contrast)
*   Test your work at zoom 200%. You must still be able to read the content and use the site.
    *   Do not disable zooming for any reason.
    *   Use rem or % for font sizes to ensure they obey browser settings.
    *   [1.4.4 Resize text - Level AA](https://www.w3.org/WAI/WCAG21/quickref/#resize-text)
*   Do not use images of text.
    *   If images of text are required, that content must also be provided in an alternative text format.
    *   Logos are exempt from this rule.
    *   [1.4.5 Images of Text - Level AA](https://www.w3.org/WAI/WCAG21/quickref/?showtechniques=145#images-of-text)
*   Do not justify text.
    *   Though this is a Level AAA item, it is a practice Kanopi follows.
    *   [1.4.8 Visual Presentation - Level AAA](https://www.w3.org/WAI/WCAG21/quickref/?showtechniques=145#visual-presentation)
*   Line spacing must be a minimum of 1.5 for body text.
    *   Though this is a Level AAA item, it is a practice Kanopi follows.
    *   [1.4.8 Visual Presentation - Level AAA](https://www.w3.org/WAI/WCAG21/quickref/?showtechniques=145#visual-presentation)
*   Build responsively. Check your work at all viewports from 320px and up.
    *   [1.4.10 Reflow - Level AA](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132#reflow)
*   Line-height must use no measurements, or it must use rems (by default line-height uses rem).
    *   User must be able to change site line-heights and still be able to view and use all content.
    *   [1.4.12 Text Spacing - Level AA](https://www.w3.org/WAI/WCAG21/quickref/?showtechniques=1410%2C1412#text-spacing)

---

### Principle 2 - [Operable](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C332#principle2) 

*   All site functionality must be operable through a keyboard interface. 
    *   Menu buttons, close buttons, links, sliders, tabs, accordions, etc.
    *   [More About Keyboard Testing](#keyboard)
    *   [2.1.1 Keyboard - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C332#keyboard)
*   Do not trap a user via keyboard.
    *   [More About Keyboard Testing](#keyboard)
    *   [2.1.2 No Keyboard Trap - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C332#no-keyboard-trap)
*   Videos, audio, gifs, moving, or auto scrolling content must include Pause, Stop, Hide controls.
    *   [More About Video & Audio](#videos)
    *   [More About Motion & Animation](#motion)
    *   2.2.2 Pause, Stop, Hide - Level A
*   Do not design content in a way that is known to cause seizures or physical reactions.
    *   Includes videos and gifs.
    *   [More About Motion & Animation](#motion)
    *   [2.3.1 Three Flashes or Below Threshold - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C332#three-flashes-or-below-threshold)
*   Add a "skip to" link that bypasses the header and goes straight to the main content.
    *   [More About Landmarks](#"landmarks")
    *   [2.4.1 Bypass Blocks - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C332#bypass-blocks)
*   Webpages must have titles that accurately describe the purpose of the page.
    *   [2.4.2 Page Titled - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C332%2C242#page-titled)
*   Focus order should be sequential and logical.
    *   Exceptions can be made, but only if the result is not confusing.
    *   [More About Keyboard Testing](#keyboard)
    *   [2.4.3 Focus Order - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C332#focus-order)
*   All links must have textual content that indicates where the link goes. 
    *   "Read More" / "Learn More" are not appropriate link names on their own.
    *   Screen reader text can be added to most links to provide article titles, or other context about the destination.
    *   Images used as links must use their alt text to identify the destination of the link.
    *   [More About Links](#links)
    *   [2.4.4 Link Purpose (In Context) - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C246%2C332#link-purpose-in-context)
*   Do not misuse headings to achieve a design.
    *   Headings are meant to describe a topic or a purpose, not as an application of style.
    *   [More About Headings](#headings)
    *   [2.4.6 Headings and Labels - Level AA](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C246%2C332#headings-and-labels)
*   The keyboard focus must be visible.
    *   Focus status should not be subtle changes. The outline property is well known and easily identified.
    *   Do not disable the default focus styles if you do not intend to replace them.
    *   [More About Keyboard Testing](#keyboard)
    *   [2.4.7 Focus Visible - Level AA](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C246%2C332#focus-visible)
*   Use section headings appropriately.
    *   Headings should be used [sequentially](https://webaim.org/techniques/semanticstructure/#correctly).
    *   Though this is a Level AAA item, it is a practice Kanopi follows.
    *   [More About Headings](#headings)
    *   [2.4.10 Section Headings - Level AAA](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C332#section-headings)
*   Ensure target sizes on mobile are easy to tap.
    *   Target size is at least 44px by 44px.
    *   Does not apply to inline links and typically does not apply to navigation lists.
    *   Though this is a Level AAA item, it is a practice Kanopi follows.
    *   [2.5.5 Target Size - Level AAA](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C255%2C332#target-size)

---

### Principle 3 - [Understandable](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C255%2C332#principle3)

*   All pages must have a language code.  
    *   Sections of content that is presented in another language must also identify the language used.
    *   [3.1.1 Language of Page - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C255%2C332#language-of-page)
    *   [3.1.2 Language of Parts - Level AA](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C255%2C332#language-of-parts)
*   Form inputs must include textual error messages.
    *   [More About Forms](#forms)
    *   [3.3.1 Error Identification - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C255%2C332#error-identification)
*   Form inputs must include labels or instructions.
    *   [More About Forms](#forms)
    *   [3.3.2 Labels or Instructions - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C255%2C332#labels-or-instructions)

---

### Principle 4 - [Robust](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C255%2C332#principle4)

*   Do not leave broken tags or stray tags.
    *   [4.1.1 Parsing - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C255%2C332#parsing)
*   Elements must be nested according to their specifications.
    *   Do not put a  `<div>`  inside a  `<p>`  or an  `<a>`  inside an  `<a>` 
    *   If you are unfamiliar with valid HTML, please reach out to your manager for training.
    *   [4.1.1 Parsing - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C255%2C332#parsing)
*   Do not duplicate IDs within a page.
    *   IDs must be unique. Use a class instead if the element will be duplicated on a page.
    *   [4.1.1 Parsing - Level A](https://www.w3.org/WAI/WCAG21/quickref/?currentsidebar=%23col_overview&showtechniques=111%2C131%2C132%2C1410%2C241%2C242%2C243%2C255%2C332#parsing)

  
<h2 id="testing-accessibility" class="anchor-heading">Testing Accessibility {% include Util/link_anchor anchor="testing-accessibility" %} {% include Util/top %}</h2>

*   Use a keyboard to operate all components of the site
    *   Also check focus order and focus states
    *   [More About Keyboard Testing](#keyboard)
*   Zoom to 200%
    *   Repeat keyboard testing
    *   Ensure all content is still readable and usable
*   Automated Scans
    *    [aXe](https://www.deque.com/axe/devtools/) - Required
    *   [Site Improve's browser extension](https://www.siteimprove.com/integrations/browser-extensions/) - Recommended
    *   [WAVE](https://wave.webaim.org/) - Recommended
    *   [More About the Auditing Tools](#audit)
*   Check uncertain color combinations with a [contrast checker](https://webaim.org/resources/contrastchecker/)
    *   If text appears overtop of an image, sample the color closest in hue to the color of the text and run it through the checker. If it fails, then you need to change the color of the text, or add an overlay to the image, or both.
*   Manual review
    *   Images do not contain text
    *   Images have appropriate alt text
    *   Headings are used sequentially
    *   Hover states exist 
    *   Site is responsive and reflows properly from 320px and up
*   Screen Reader Testing
    *   Alternatively, your developer tools will give you access to the accessibility tree which will give you an indication of what content is being passed through to assistive technology.
    *   [More About Screen Readers](#screenreader)



<h2 id="a11y-teaching-learning" class="anchor-heading">A11y Teaching & Learning {% include Util/link_anchor anchor="a11y-teaching-learning" %} {% include Util/top %}</h2>

Ally Teaching & Learning is a monthly session Kanopians can attend to talk through accessibility concepts and guidelines. You can find all of [our sesson documents here](https://intranet.kanopi.com/human_resources/policies_and_processes/tools/accessibility_documents), or search for the term "[Accessibility](https://intranet.kanopi.com/?search=&labels=684494)". Some intranet documents include session videos.



<h2 id="wcag" class="anchor-heading">WCAG Guideline Quick Reference {% include Util/link_anchor anchor="wcag" %} {% include Util/top %}</h2>

There are 4 specific aspects of the WCAG guidelines and they are defined by the acronym "POUR". This is a general summary of what you can find in each area.

---

### [1 Perceivable:](https://www.w3.org/WAI/WCAG21/quickref/?showtechniques=413#principle1)


Everything in the 1 point rule set has to do with an individual’s ability to perceive the content. It’s broken out into four areas.

#### 1.1 - Text Alternatives.

*   Could someone perceive this content if they were unable to see it?
*   Can a machine without eyes understand this content? That’s how assistive technologies work.

#### 1.2 - Time-based Media.

*   Can anyone, regardless of ability or disability, consume your media?
*   What if they can only see?
*   What if they can only hear?
*   What if they can do neither and depend on assistive technology to interpret content in another manner such as Braille?
*   What if they have motor difficulties that prevent them from using the interface quickly?

#### 1.3 Adaptable

*   Do users need to meet specific requirements in order to perceive your page and its content?
*   Can content be perceived and understood with changes to screen size?
*   Does content make sense in the order it’s presented? Is its purpose clear programatically?

#### 1.4 Distinguishable

*   Is the presentation clear and understandable?
*   Is content easily identified without needing context clues like color?
*   Does the design interfere with the ability to consume content?
*   Does anything interfere with the user’s ability to use the whole page? (For example, an autoplay video or audio file would be considered an interference).

---

### [2 Operable:](https://www.w3.org/WAI/WCAG21/quickref/?showtechniques=413#principle2)


Everything in the 2 point rule set has to do with an individual’s ability to operate the page. It’s broken out into five areas.

#### 2.1 - Keyboard Accessible

*   Can a user operate this page with just a keyboard? 
*   Can all of the links and interactive elements be reached and activated via keyboard?
*   This is critical because many assistive technologies operate with keyboard interactions.

#### 2.2 - Enough Time

*   Does the user have the time to operate the page?
*   Are there timed interactions?
*   Are there elements that cause interruptions?
*   Can users control media so that they can consume it at their leisure?

#### 2.3 - Seizures and Physical Reactions

*   Does this site follow good practices to prevent experiences that are known to cause seizures?

#### 2.4 - Navigable

*   Can the user move around the page in a logical manner?
*   Is link purpose clear?
*   Does the content have appropriate headings and labels?

#### 2.5 - Input Modalities

*   Are target/tap sizes appropriate?
*   Are target/tap areas too close together?
*   Does the site rely on swipes or gestures to complete actions and tasks? 
*   Are there alternatives present?

---

### [3 Understandable:](https://www.w3.org/WAI/WCAG21/quickref/?showtechniques=413#principle3)


Everything in the 3 point rule set has to do with an individual’s ability to understand the page. It’s broken out into three areas.

#### 3.1 - Readable

*   Is the language programmatically determined?
*   Is the content understandable without additional context?
*   Are there mechanisms for identifying the definitions of abbreviations, industry jargon, idioms, etc?
*   Is the reading level appropriate? 
*   Is meaning ambiguous without knowing pronunciation?

#### 3.2 - Predictable

*   Does the page conform to a standard web experience?
*   Does focusing an element or using an input field produce typical expected behaviour?
*   Is navigation consistent from page to page?
*   Are components with the same functionality identified consistently throughout the site?
*   Are changes of context appropriately managed?

#### 3.3 - Input Assistance

*   Are input errors easily identified and described to the user?
*   Are inputs accompanied by labels and, when appropriate, instructions?
*   Do errors include suggestions for correction?
*   When collecting legal information, does the user have the ability to correct and review their submissions?

---

### [4 Robust:](https://www.w3.org/WAI/WCAG21/quickref/?showtechniques=413#principle4)


Everything in the 4 point rule set has to do with a device’s ability to understand the page. It’s broken out into one area.

#### 4.1 - Compatible

*   Is the site compatible with current user agents (browsers, operating systems, assistive technologies)?
*   Will the site be compatible with future user agents (browsers, operating systems, assistive technologies)?
*   Do all interface-able components provide enough information that their name and role can be programmatically determined?
*   When states, properties, or values are changed, is that change made available to user agents?
*   Are status messages presented to the user without requiring focus?


<h2 id="images" class="anchor-heading">Images {% include Util/link_anchor anchor="images" %} {% include Util/top %}</h2>

Images make up a good portion of a website's design and content, but aren't accessible to users with low or no vision. How do we make sure they get conveyed to users of assistive technology?

### When do they need the "alt" attribute?

**Always.** This can't be understated. If you are using `<img>` or `<svg>`, then you need the alt attribute. This is to create valid HTML and also passes important info about the image to assistive technologies.

These are all valid html:

```
<img href="path-to-iamge" alt />
<img href="path-to-iamge" alt="" />
<img href="path-to-iamge" alt="An image of a fluffy orange cat playing with a feathered toy" />
```

Images that are applied via CSS cannot be given the alt attribute. If your image is important for conveying meaning to a user, you need to find an alternative method for providing that context, perhaps through a caption or hidden screen reader text.

### What happens if the image has no alt attribute?

If your image has no alt attribute, then the image name will be presented instead. 

*   img\_NCBI-macbook-1x-1-743x475
*   Kanopi-Icon-Confused-Editor-Trimmed
*   logo-phr@2x-grey
*   iStock\_Civic-425x275

### When does the alt tag need to be filled in?

Only if the image is not classified as decorative.

Decorative images could be:

*   Background designs like dots, arrows, swoops
*   Icons that accompany visual labels
*   Lines, shapes, other items that frame headings or other content

Images that are important enough to present to a sighted user are important enough to present to a user with reduced vision.

### What about Icons?

If an icon is use decoratively - that is to enhance a label - then they do not need alt text, just the alt attribute. Or if they're applied via css, then they do not need any sort of attribute.

Icons that sit alone and have no associated label, or add additional context to a label, need to have alt text. A good rule of thumb is if this icon was missing, is context lost? If so, then it needs additional information.

For example:

*   A phone icon next to a phone number would be fine with an empty attribute.
*   An icon of a shopping cart with no label would need alt text.

### What about when the image is also a link?

This is very common with social media links, or logos. In this case, the alt text of the image should reflect the **purpose of the link**, not the image.

### What makes a good alt tag?

That is a good question and up for debate. There are a couple ways to approach them:

*   A literal description of the image.
    *   "Smiling Asian woman sitting on a blue couch using a tablet."
*   The intended meaning of the image.
    *   Woman happily working from home on her iPad."

Those could both be used to describe the same image, one gives you a better idea of what the image is of, the other a description of the emotion the image is meant to convey. Which is better? That's the debate. At the end of the day, make sure that users with or without vision understand the same thing.

<h2 id="landmarks" class="anchor-heading">Landmarks {% include Util/link_anchor anchor="landmarks" %} {% include Util/top %}</h2>

Landmarks are HTML elements that assistive technology can detect and navigate by. They are extremely useful when used correctly, and can cause confusion when they aren't. 


Your document should follow this structure:
```
<html>
   <head></head>
   <body>
      <a href="#main">Skip To Main Content</a>
      <header></header>
      <main id="main"></main>
      <footer></footer>
   </body>
</html>
```
All of your content should be inside the `<header>`, `<main>`, or `<footer>`. The primary exception to this rule is the Skip To Link can be outside of these landmarks (this is recommended by Deque, the providers of aXe). The other exception is that `<aside>` can exist at this same level, however it can also be used within `<main>` and that is preferable.

Cookie notices are typically added via third party javascript and are placed after the footer. This is outside our control and not a large concern.

---

### `<header>`

non-semantic: `<div role="banner">`

*   Always use `<header>` unless you can't, in which case you can assign the roll of banner.
*   "Banner" does not mean "hero." It is expected that this element will contain the main navigation.
*   Limited to 1 per page.
*   When used inside these elements, it becomes `role="generic"`, therefore does not break the previous rule.
    *   `<aside>`
    *   `<article>`
    *   `<main>`
    *   `<nav>`
    *   `<section>`

---

### `<main>`

non-semantic: `<div role="main">`

*   Always use `<main>` unless you can't, in which case you can assign the roll of main.
*   This is the primary content of the document.
*   The `<h1>` should be placed within this area.
*   Limited to 1 per page
*   This is where a bypass "skip to link" should target

---

### `<footer>`

non-semantic: `<div role="contentinfo">`

*   Always use `<footer>` unless you can't, in which case you can assign the roll of contentinfo.
*   Appropriate for copyright info, nav links, privacy statements, etc.
*   Limited to 1 per page.
*   When used inside these elements, it becomes `role="generic"`, therefore does not break the previous rule.
    *   `<aside>`
    *   `<article>`
    *   `<main>`
    *   `<nav>`
    *   `<section>`

---

### `<aside>`

non-semantic: `<div role="aside">`

*   Always use `<aside>` unless you can't, in which case you can assign the roll of complimentary.
*   For content related to the main content, but that can also stand alone when separated.
*   Multiple can be used, but must be labeled by aria-label or aria-labelledby.
*   Can be used inside any [flow content element](https://developer.mozilla.org/en-US/docs/Web/HTML/Content_categories#flow_content), and can even be placed outside `<main>` if necessary

---

### `<nav>`

non-semantic: `<div role="navigation">`

*   Always use `<nav>` unless you can't, in which case you can assign the roll of navigation.
*   Multiple can be used on a page, but each must be labeled by unique aria-labels.
*   Don't put a heading inside this, it's redundant. Use the aria-label.
*   You do not need to specify that it is a navigation in the aria-label. "Legal", "Main", "Utility", "Account", etc. are sufficient.

---

### `<section>`

non-semantic: `<div role="region">` or  `<div role="generic">`

*   Regions have accessible names, that is an aria-labelledby that relates to a heading within the content.
*   If no visible header is present, then aria-label is appropriate.
*   If the section does not have an accessible name, then it is considered generic and loses the region role.

---

### `<article>`

non-semantic: `<div role="article">`

*   A section of a document, page, or site that, if it were standing on its own, could be viewed as a complete document, page, or site.
*   Are not considered navigational landmarks, but some assistive technology does support navigating these elements.
*   Multiples permitted, and in the case of sibling articles they will be considered related.

---

### `<div>` or `<span>`

non-semantic: `<div role="generic">`

*   Does not recognize the aria-label or aria-labelledby attributes unless a role that accepts those attributes is assigned.

---

### Example of Landmarks in Use

```
<html>
   <head></head>
   <body>
      <a href="#main">Skip To Main Content</a>
      <header>
         <nav aria-label="Utility">Navigation Items</nav>
         <nav aria-label="Main">Navigation Items</nav>
      </header>
      <main id="main">
           <h1>Company News</h1>
           <section aria-labelledby="heading2a">  
              <h2 id="heading2a">Announcements</h2>
              <div>Content</div>
           </section>
           <section aria-labelledby="heading2b">
              <h2 id="heading2b">Latest Posts</h2>
              <article>Content</article>
              <article>Content</article>
              <article>Content</article>
              <article>Content</article>
           </section>
           <aside aria-label="Upcoming Event">
              <div>Content</div>  
           </aside>
           <aside aria-label="Training Webinars">  
              <article>Content</article>  
              <article>Content</article>
              <article>Content</article>
              <article>Content</article>
           </aside>
      </main>
      <footer>
         <nav aria-label="Footer">Navigation Items</nav>
         <nav aria-label="Legal">Navigation Items</nav>
      </footer>
   </body>
</html>
```



<h2 id="videos" class="anchor-heading">Videos & Audio
 {% include Util/link_anchor anchor="videos" %} {% include Util/top %}</h2>

[Resource](https://www.w3.org/WAI/media/av/planning/)

**Note:** Not all platforms are accessible, or may need to be configured at the account level for accessibility 

*   YouTube - accessible
*   Vimeo - accessible with some edge case errors
*   Wistia - can be made accessible with configuration at the account level

  

### Content Videos

*   Captions are always required \*
    *   Auto generated captions are acceptable, but custom captions are recommended
*   Must not cause seizures
*   Must not autoplay
*   All controls must be usable by keyboard
*   Require play / pause / stop controls

  

### Background Videos

*   Must not cause seizures
*   Autoplay is permitted
*   All controls must be usable by keyboard
*   Require play / pause / stop controls
*   Require a descriptive transcript \*\*

  

### Audio Content

*   All controls must be usable by keyboard
*   Require a transcript \*\*\*
*   If autoplay is implemented, there must be a mechanism for users to silence it independently from their computer controls
    *   Play / pause / stop controls
    *   Silence button
  

### Transcripts / Sign Language


#### Video w/ Audio \*
*   Captions are required to meet Level AA
    *   If the video has generic unimportant audio, you can omit captions by informing users that the audio is unimportant.
        *   Example: "This video has no audio apart from instrumental background music."
    *   If the video does not provide any additional information, you can omit a descriptive transcript by informing users of that fact.
        *   Example: "The visuals in this video only support what is spoken; the visuals do not provide additional information."
*   Transcripts are required to meet Level AAA
*   Accompanying Sign Language is required to meet Level AAA

  

#### Video Only (no audio)

*   You must provide a descriptive transcript of the video content to meet Level A
    *   If the video does not provide any additional information, you can omit a descriptive transcript by informing users
        *   Example: "The visuals in this video do not provide additional information."

  

#### Audio Only (no video) \*\*\*

*   You must add a way for the user to view the transcript to meet Level A
    *   If the audio is generic and unimportant, you can omit a transcript by informing users that the audio is unimportant.
        *   Example: "This sound file has no audio apart from instrumental background music."

---  

**Note:** Live Streams (audio and video) are subject to different rules for accessibility.

---

<h2 id="motion" class="anchor-heading">Motion & Animation
 {% include Util/link_anchor anchor="motion" %} {% include Util/top %}</h2>

 ### What is Animation?
    
*   Videos
    
*   Gifs
    
*   Animated backgrounds
    
*   Animated illustrations
    
*   Carousels
    
*   Slideshows
    
*   Loading icons do not count

### What is Motion Animation?
    
*   Triggered by user interaction
    
*   Animation that is used to "create the illusion of movement"
    
*   Does not include changes of color, blurring, or opacity
        
---

### Motion Animation 

These are all common elements with items like link / button hovers, and are not a problem to implement:
    
*   Color transitions 
    
*   Opacity changes 
    
*   Blur effects
        
Items that would count as motion animation:
    
*   Parallax
    
    *   Parallax is popular but also seems to be universally problematic for people with motion sensitivities. 
        
*   Background elements that move with the page / background on scroll
    
*   Animation that is used to "create the illusion of movement"
        
*   Fading in / out
    * This is often triggered on scroll, so could be considered motion animation. However, it also relies on opacity changes so it could be considered exempt. Ultimately if it is animation that is used to create the illusion of movement, then it should be considered problematic.
    

### Avoid Unnecessary Animations

*   Context does play a part here. For example, a website about a video game would reasonably employ a great deal of movement, whereas on a government site or a construction company site the same level of motion would seem out of place.
    
*   Consider the context and expectations of the site and consider whether the amount of animation in the design fits.
    

### Provide an Off / Reduce Switch

*   If the site has motion animation, add to the design & function a method for the user to disable them.
    
*   Typically this is designed as a toggle, but could also be settings or preference for a user with an account tied to the site.
    
*   Does not have to stop all motion animation, but at the very least should reduce it.

*   If you do not want to add a switch, then be sure your motion animation automatically obeys user settings for Reduced Motion.
    

### Prefer Reduced Motion Feature

*   Users can set this in their operating system to indicate that they prefer reduced motion. We can use the media query  prefers-reduced-motion  to change how our styles work for users with this setting. It’s accessible via css as well as javascript.
    
*   You can use both this method and the previous one together by automatically toggling the switch based on the user settings.

---

### Pause, Stop, Hide

*   For any moving, blinking or scrolling information that (1) starts automatically, (2) lasts more than five seconds, and (3) is presented in parallel with other content, there is a mechanism for the user to pause, stop, or hide it unless the movement, blinking, or scrolling is part of an activity where it is essential.
    
*   Carousels and Slideshows set on auto loop or autoplay are considered longer than five seconds, even if each individual animation is less than five seconds.
    
*   This means animations that fall under these criteria require visible controls.
    
    *   Example of an animation that does not: Our animated logo. It autoplays, however it is less than 5 seconds and does not loop.
        
    *   Example of an animation that does: the embedded gif on our 404 page
        
*   There are no specific design requirements for controls, so designers have a lot of freedom with how they look, however it is a good idea to check if the item already has controls as it can be difficult and time intensive to customize (and in some cases may not even be possible). 
    
*   Background videos are subject to the same need for controls. 
    

### Three Flashes or Below Threshold

*   Significant flashing on screen has been known to trigger seizures.
    
*   Web pages do not contain anything that flashes more than three times in any one second period, or the flash is below the general flash and red flash thresholds.
    
*   It’s easiest just to avoid anything that flashes more than three times in one second
    
*   If flashing can’t be avoided, follow the WCAG guidelines to meet the safe thresholds (there are details in WCAG about the size, ratio, and viewing angle that can be followed to produce a flashing screen that would be considered safe.). 
    
    *   A text-only version of the content should be provided
        
    *   Advanced warning of a potential flashing hazard


<h2 id="aria" class="anchor-heading">ARIA {% include Util/link_anchor anchor="aria" %} {% include Util/top %}</h2>


### What is ARIA?

*   ARIA in HTML is an \[HTML\] specification module.
    
*   Incorrect or Bad ARIA can create nonsensical UI information for assistive technologies
    

### Roles

*   Roles CHANGE the exposed meaning (semantics) of HTML elements.
    
*   If it is an html element apart from "div" or "span", it has an inherent role. You do not need to define a role, unless you wish to CHANGE the role.
    
    *   eg. `<header>` has a role of "banner", `<footer>` has a role of "contentinfo", you do not need to add these roles.
        
*   Roles may have requirements for nested elements. Do not use a role without checking the requirements for direct descendants. 
    
    *   Example: `<ul>` element given the role of "menu" means each `<li>` must then have a role of "menuitem"
        
*   If you don’t actually know what the role does, do not use it!
    
    *   Example: `role="menuitem"` indicates the element is an option in a set of choices contained by a menu or menubar - it is NOT a navigation element.
        
*   Avoid overriding interactive elements, such as buttons, details/summary, etc.
    

### Extending HTML

*   ARIA can be used to extend and diverge from HTML.
    
    *   Example: `<button>` does not have a pressed state, but you can provide one by using `aria-pressed="true"` to expose that information to users of assistive technologies.
        
    *   Likewise, you could add an `aria-disabled="true"` on a button, which would be conveyed to assistive technologies where adding "disabled" to a link or button would not be understood.
        
*   Don’t use ARIA to augment your html without fully understanding the ARIA you’re using. You can create incredibly complex and confusing experiences with incorrect ARIA. They say "no ARIA is better than bad ARIA".
    

### Writing HTML

*   ARIA should not be used to fix invalid html.
    
    *   Example: you cannot put a `<div>` with a `role="link"` inside a `<p>`. A `<div>` does not go inside a `<p>` no matter what role it is given.
        
*   Use the most correct HTML instead of overriding HTML with ARIA
    
    *   Example: do not give `<article>` a role of "generic" - just use a `<div>` which is generic by default.
        
---

### Resources:

[W3C ARIA Guide](https://www.w3.org/TR/html-aria/)

[Mozilla ARIA Guide](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles)

---

<h2 id="forms" class="anchor-heading">Forms {% include Util/link_anchor anchor=forms %} {% include Util/top %}</h2>

 ### Icons as Labels

*   Icons MAY be used as visual labels (without visual text) if the meaning of the icon is visually self-evident **and** if there is a programmatically associated semantic label available to assistive technologies.
    
### Placeholder Text as Labels

*   Placeholder text **must not** be used as the only method of providing a label for a text input.
    

### Visibility of Labels

*   Labels MUST be visible.
    
*   For user interface components with labels that include text or images of text, the name **must** contain the text that is presented visually.


### Proximity of Labels to Controls

*   A label **should** be visually adjacent to its corresponding element.
    
*   A label **should** be adjacent in the DOM to its corresponding element.
    
### Custom Form Inputs

*   Native HTML form elements SHOULD be used whenever possible.
    
*   Custom form elements **should** act like native HTML form elements, to the extent possible.
    
*   Custom form elements **should** have appropriate names, roles, and values.
    
*   Updates and state changes that cannot be communicated through HTML or ARIA methods **should** be communicated via ARIA live messages.
    

<h2 id="keyboard" class="anchor-heading">Keyboard {% include Util/link_anchor anchor="keyboard" %} {% include Util/top %}</h2>
 
 Coming Soon...


<h2 id="audit" class="anchor-heading">Accessibility Auditing Tools
 {% include Util/link_anchor anchor="audit" %} {% include Util/top %}</h2>


It is generally accepted that [automated tools can only detect about 30%](https://www.levelaccess.com/blog/automated-accessibility-testing-tools-how-much-do-scans-catch/) of WCAG’s 2.1 success criteria (some sources say 40%, some say 20%, most say 30%). That means providing a "score" is very difficult. Testing requires both automated tools and manual tests. Each automated tool will have a slight variation in results, and it's recommended that you utilize multiple tools when testing.[](https://wave.webaim.org/)

### [aXe Browser Extension](https://www.deque.com/axe/devtools/)

#### How To Use:

Install the extension, then from developer tools you can select aXe DevTools. Once the area is open, you can simply run a scan. If you have a paid plan with Deque there are additional options but the free version is sufficient. 

#### Best Features:

If you only use one automated tool, make it this one. It has the most accurate and streamlined results by far, shows user impact, and provides significant information on each ruleset. "More information" on each result links over to Deque's aXe ruleset, which provides context for the problems the error can cause, more information about the user impact, which guidelines are relevant, and options for solving.

#### Pros:

*   Shows Level A and Level AA errors
*   Best Practice items can be toggled on and off
*   Groups errors by serious, critical, moderate, and mild errors
*   Groups uncertain items for manual review
*   Links errors to Deque’s aXe ruleset
*   Explains specific fix options for each error
*   Links directly to code in Developer Tools
*   Rarely gives false positives

#### Cons:

*   Extension can be overwhelming and difficult to use for non-developers 
*   Does not scan hidden items
*   May or may not scan javascript injected content

### [WAVE](https://wave.webaim.org/)

#### How To Use:

Merely go to the site and input the url of the page you wish to scan. Use the tabs to get a closer look at the details of the page.

#### Best Features:

The ability to see the heading structure on the page via the Structure tab, as well as the links via the order tab. This is the closest equivalent to a screen reader experience without using a screen reader.

Also, WAVE will check for justified text (Level AAA item). None of the other automated scans are known to do this.

#### Pros:

*   Easy to use via URL
*   Allows toggling styles and javascript on and off for scans
*   Attractive visual interface
*   Shows Level A items as errors (red)
*   Shows Level AA, AAA, and Best Practice items as warnings (orange)
*   Identifies all ARIA used
*   Identifies all structural elements
*   Identifies accessibility features applied
*   Identifies contrast errors separately 
*   Provides helpful information regarding error
*   Links errors to WebAIM’s WCAG 2 Checklist
*   Links directly to code in Developer Tools
*   Has built in contrast checker

#### Cons:

*   Cannot scan javascript injected content
*   Generates a few false positives each scan

### [Site Improve Browser Extension](https://www.siteimprove.com/integrations/browser-extensions/)

#### How To Use:

After you add the extension, there will be an icon you can add to your browser bar. Clicking it will toggle SiteImprove open and begin a scan. 

#### Best Features:

You can open developer tools at the same time. Like aXe, it links errors to the actual code in the inspector, but SiteImprove error report can be kept open for reference (a problem aXe has, since it occupies the same space as the inspector).

#### Pros:

*   Scans for Level A, Level AA, and Level AAA errors
*   Includes scans for Best Practices
*   Extension can be configured to filter
    *   For any level (including Best Practice)
    *   For errors or warnings
    *   For items to review
    *   For items likely to be related to content entry
    *   For items likely to be related to development
*   Links errors to WCAG 2:1 Guidelines
*   Links directly to code in Developer Tools
*   Groups errors by guideline

#### Cons:

*   Aggressive scan causes frequent false positives
*   Difficulty understanding javascript injected content
*   Displays many Level AAA and Best Practice items as falling under Levels A and AA
    *   The more I look into this, the more I understand why SiteImprove results are like this. If you look at any [WCAG 2.1 guideline](https://www.w3.org/WAI/WCAG21/quickref/) you'll see a number of techniques. Some of them are only applied in specific situations, and some are advisory, meaning they aren't required but are highly recommended. Advisory items often make it into Level AAA rules. SiteImprove is lumping all situations and advisory techniques into the lower level rule, regardless of their relevancy. It also harshly judges Failure of Success Criterion, sometimes failing items because they could be implemented incorrectly and not because they are implemented incorrectly.

### [Google Lighthouse](https://chrome.google.com/webstore/detail/lighthouse/blipmdconlkpinefehnmjammfjpmpbjk)

#### How To Use:

When using Chrome, this is an option in development tools. It's best to run your scans incognito, and it's recommended that you select "mobile" instead of desktop (mobile scores are weighted more heavily).

#### Best Features:

Lighthouse offers accessibility, SEO, performance, and Best Practice metrics. This is useful for tracking a site's improvements or shortcomings in regards to its standing with Google, which drives the search engine ecosystem. 

It's also very easy to use, and provides downloadable PDF reports of its findings.

#### Pros:

*   Provides scores out of 100 (for people who love metrics)
*   Gives advice for manual checks
*   Easy to use extension
*   Generally no false positives
*   Identifies target size errors
*   Can also provide SEO and Performance audits
*   Links errors to Deque’s aXe ruleset

#### Cons:

*   Very simple scan
*   Provides minimal information regarding errors
*   Only audits 44 possible accessibility errors
    *   This is the primary drawback of Lighthouse. Getting 100/100 is very easy and can give the false impression that someone's website is accessible. 

### [ANDI](https://www.ssa.gov/accessibility/andi/help/install.html)

#### How To Use:

Visit the [ANDI url](https://www.ssa.gov/accessibility/andi/help/install.html) and drag the pink button to your bookmarks bar. Then visit any website and click that bookmark. ANDI will open an interface at the top of the page.

#### Best Features:

ANDI is a fantastic introductory into the world of accessibility due to its interface and categorization of items. It automatically highlights errors on the page as you click them, and presents code information in an easy to digest manner.

#### Pros:

*   Extremely easy to install
*   Very visual interface
*   Provides information on how a screen reader might interpret some elements
*   Great entry into understanding what kinds of errors can exist
*   Has built in contrast checker

#### Cons:

*   Does not link errors to guidelines
*   Limited suggestions for fixes

  
---

### Manual Testing


Manual testing is necessary. While automated tools can detect places errors could possibly be, it can't necessarily determine if an error is present. For example, they can tell you if an alt is present on an image, but they can't tell you if the alt is appropriate for that image. 

In addition to that, there are plenty of things that simply cannot be scanned for.

#### Manual Review

There are a number of items you need to specifically look for as a human. This is not a comprehensive list but it is a good place to start.

*   Images do not contain text
    *   Or if they do, that text is also presented as textual content for users of assistive technology.
*   Images have appropriate alt text
    *   If it is decorative (swoops, shapes, waves, patterns, icons beside headings or labels) then an empty alt is appropriate. This will make assistive technology skip it.
    *   If it is not decorative (icons without labels or headings, content images) then it must have an alt text that describes the content.
    *   If it is an image wrapped in a link, the alt text must describe where the link goes instead of the image content.
*   Headings are used sequentially
    *   Tools do pick this up, but usually will only identify the first error. Once it's been resolved, a new error appears on a secondary scan. This is just due to the cascading nature of headings. If you look for these manually you can resolve them all in one go instead of the back and forth yo-yo of testing.
*   Hover states exist 
    *   There are no specific rules that relate to hover states, however it is extremely useful and considered Best Practice. You can also add these hover states to focus states to create a uniform experience.

#### [WebAim Contrast Checker](https://webaim.org/resources/contrastchecker/)

There are a variety of contrast checkers online and there's no hard rule about which one to use, but this is the go-to for our audit process. If there is ever a question of whether something meets contrast, you can double check the results here.

If text appears overtop of an image, sample the color closest in hue to the color of the text and run it through the checker. If it fails, then you need to change the color of the text, or add an overlay to the image, or both. Some automated tools will alert you to review these items, some will not.

*   Level AA contrast (minimum) requirement is 4.5:1
*   Large text can pass at 3:1 provided items are one of the following:
    *   Font size 24px
    *   Font size 19px - 23px and bold
*   Graphical objects and UI components like icons, borders, etc, need to meet the 3:1 ratio
*   Level AAA contrast requires 7:1 for normal text, 4.5:1 for large text, and 3:1 for graphical elements

#### [Readability Test](https://www.webfx.com/tools/read-able/)

Reading level is a Level AAA item but it is worth checking to see if the page meets the reading ability of its demographic. The Level AAA requirement is that reading ability should not be more advanced than the lower secondary education level.

#### [Screaming Frog](https://www.screamingfrog.co.uk/seo-spider/)

Kanopi does have a Screaming Frog license. This tool allows you to scan the entire site for pages missing h1's, pages with multiple h1's, as well as images that are missing alt text. 

#### Keyboard

*   [More About Keyboard Testing](#keyboard)
*   Use a keyboard to operate all components of the site
    *   You must be able to do every interaction without the use of a mouse
*   Check that the focus order makes sense
    *   WAVE can provide you with a visual representation of the focus order as well in its order tab
    *   FireFox developer tools has an accessibility feature to show focus order
*   Check that the focus is visible on all interactive elements

#### Zoom to 200%

*   Repeat keyboard testing while zoomed into 200%.
*   Ensure all content is still readable and interactive elements are still usable.

#### Responsive

While it is common to merely check the site at specific breakpoints, remember this is a fluid and flexible medium and the "standard" breakpoints aren't the only viewports that will be used. 

Check the site from 320px and up. If your browser window does not go that small, open the developer tools as a sidebar and you can then create a smaller viewport of the web content. Move up to full desktop and check that everything reflows correctly and is still readable and usable along the way.

Unless an application calls for scrolling in two dimensions (such as a map or complex table), users should never be required to scroll in two dimensions to consume content. Also make sure users can scroll past applications that do have a side scroll without getting stuck in the application.

[1.4.10 Reflow - Level AA](https://www.w3.org/WAI/WCAG21/quickref/?showtechniques=1410%2C1412#top) for reference.

---

### Screen Reader Testing

*   [Screen Reader 101](https://kanopi.com/blog/screen-reader-101/)
*   [More About Screen Readers](#screenreader)
*   [Deque VoiceOver shortcuts](https://dequeuniversity.com/screenreaders/voiceover-keyboard-shortcuts)

Using a screen reader takes a lot of practice and skill. Native users have dozens of keyboard shortcuts memorized and have developed non-linear methods of consuming webpage content. They use the rotor with ease and often have their speech synthesizer running at high speeds. 

You can configure your Mac VO in System Settings. Find a speed and voice that works for you, then open a web page and activate the screen reader with CMD + F5. From there you can either use the arrow keys to move down the page in a linear fashion, or you can click on items to have them read aloud (provided they are not interactive). Once you feel comfortable, try the Deque VoiceOver guide on using shortcuts and the rotor.

#### Accessibility Tree

If using a screen reader is daunting, open development tools and look for an "accessibility" tab. This will show you what kind of information is being passed through to a screen reader.

*   Chrome's accessibility tree is in the toolbar that has "styles", "computed", "layout", etc.
*   FireFox's accessibility tree is available from the same right click menu that you use to inspect an element.
    *   FireFox's accessibility tree is more robust than Chrome's if you're seeking additional information about an element.

This is mostly helpful for troubleshooting strange results experienced via screen reader, but this does allow you to see the exact understanding a machine has of any given element. You can see the roll, any attached aria, it's placement in the DOM tree, and its semantics.

Practice:

*   Visit [Deque VoiceOver shortcuts](https://dequeuniversity.com/screenreaders/voiceover-keyboard-shortcuts)
*   Inspect the text "On this page" 
*   It is a paragraph
*   View the accessibility tree
*   See that the item is considered to be an h2 by the screen reader and not a paragraph 
    *   FireFox will identify the true element tag in its additional properties, but within the tree itself it considers the element to be a heading exactly the same way that Chrome does.

 <h2 id="screenreader" class="anchor-heading">Screen Readers
 {% include Util/link_anchor anchor="screenreader" %} {% include Util/top %}</h2>

 Coming Soon...


 <h2 id="links" class="anchor-heading">Links {% include Util/link_anchor anchor="links" %} {% include Util/top %}</h2>

### Links vs Buttons

*   An `<a>` takes you somewhere, and a `<button>` actions something. 
*   Links should tell you where they go, buttons should tell you what they do.
*   `<a>` always requires an href. If you do not have one, then do not use `<a>`.
*   Buttons follow the same guidelines that will be listed in this document.

### Touch Targets

While this is a Level AAA item, this is a guideline that Kanopi chooses to follow. Google’s lighthouse scan does take target size into account when determining the mobile usability of a site, and it can impact the site’s search rating.

---

[2.5.5 Target Size](https://www.w3.org/WAI/WCAG21/quickref/#target-size) guideline states:

The size of the target for pointer inputs is at least 44 by 44 CSS pixels except when:

*   Equivalent: The target is available through an equivalent link or control on the same page that is at least 44 by 44 CSS pixels;
*   Inline: The target is in a sentence or block of text;
*   User Agent Control: The size of the target is determined by the user agent and is not modified by the author;
*   Essential: A particular presentation of the target is essential to the information being conveyed.

---

Target size typically does not apply to inline text, and navigation lists are usually ignored by automated tools that detect target sizes. While those elements still need sufficient spacing, they are less strict. Ensure that each item is easily tapped without accidentally triggering an adjacent item. If you are using an icon instead of a textual link, then that target must meet the 44px by 44px requirement. 

Clarifying note, the link content does not have to be 44px by 44px, but the clickable area must be at least that big. Giant icons are not necessary to meet this requirement. 

---

### Problematic Links

These are links that can cause confusing or make it difficult for users of assistive technology to navigate your site. You can use [WAVE](https://wave.webaim.org/) to scan a site then select "Order" to see a list of links and buttons. From here you can gauge whether or not your site's links are problematic.

*   Duplicate Links
    *   One or more links on the page having the same name but going to different urls is confusing and misleading.
*   Annoying Links
    *   Full urls take a long time to read and are not always helpful.
    *   Redundant links add extra bloat to the rotor.
*   Ambiguous Links
    *   Links with Generic Text make no sense apart from context and have poor SEO value.
    *   Examples: Read More, View All, Learn More, Download, Watch Now, Click Here
    *   Since ambiguous link names are often repeated on the page, it circles back to duplicate links.

#### Duplicate Links:

Links that have the same name but go to different places are misleading. This is because users often do not look at links within context - they navigate down the page via links, or are presented with a list of links within the rotor (a screen reader tool, see image).

Imagine you had a top nav category for Programs, and a sub item of Overview. Then elsewhere you had About with a sub item of Overview. 

A user traveling the site by link would experience multiple "Overview" links and would have no idea they went to two different places, or which one to go to in order to read the desired Overview. In this screenshot of rotor results they might be able to make an educated guess based on the link order, but that will not always be the case.

![screen shot of screen reader link results with multiple duplicate links]({{ site.baseurl }}/img/a11y/rotor-links-bad.png)

It's best to specify "Program Overview", "About Overview", in one fashion or another (see adding textual content to links).

#### Annoying Links:

If you’re a big fan of science fiction, be sure to check out Star Trek Voyager on IMDB at [https://www.imdb.com/title/tt0112178/?ref\_=tt\_ov\_inf](https://www.imdb.com/title/tt0112178/?ref_=tt_ov_inf)

Not only does that link url not explain where it goes if presented apart from its context, but it would also be read aloud exactly as it is written. "H T T P S colon forward slash forward slash W W W dot imbd dot com forward slash title forward slash T T zero one one two one seven eight forward slash question mark ref underscore equals T T underscore ov underscore inf". Say that three times fast.

It is far preferable to link phrases or words than provide entire urls. Also, be sure to check out [Star Trek Voyager on IMDB](https://www.imdb.com/title/tt0112178/?ref_=tt_ov_inf).

Another way that links can be annoying and cumbersome for assistive tech is when they are repeated. Often CTAs or post cards will have an image, a title, and a button, all going to the same place. A user would then experience the same link being presented 3 times in a row. Put 9 cards on a page and now you have 18 redundant links (27 - 9). While redundant links aren't specifically addressed in the WCAG guidelines, it is generally discouraged.

#### Ambiguous Links:

Take the following paragraph:

_We wrote an [**article**](#) about how content creators can make their content more accessible. Also be sure to check out [**this article**](#) to find a step by step guide on testing your site for accessibility._

Someone with a screen reader would then find in their list of links a result for "article" and a result for "this article" but have no concept of where either go. The better version of this would be:

_We wrote an article about [**how content creators can make their content more accessible**](#). Also be sure to check out this article to find a [**step by step guide on testing your site for accessibility**](#)._

Now when reviewing the links on the page or in the rotor, a user will have a much clearer idea of where they go. 

Links such as "Click Here" or "Read More" or "View All" offer little context to the user and sites that use generic link terms are scored lower by Google. But there are options to keep the visual simplicity of these links while providing additional context to search engines and assistive technology (see adding textual content to links).

---

### Adding Textual Context to Links

*   A link must always have textual content.
*   If it is wrapped around an image, then the image’s alt must describe where the link goes. 
*   If it’s a styled link with no words, then there must be an aria-label, aria-labelledby, or screen reader text to describe its destination.
*   Links that open in a new window should alert the user

#### Standard Links

In these examples, the links are presented without any additional context. Users of assistive technology would not know where these links went unless they could actually see them in context.

```
<a href="url" target="\_blank">Register</a>
```

Presented as: Register, link.

```
<a href="url">Read More</a>
```

Presented as: Read more, link.

```
<a href="url">View all</a>
```

Presented as: View all, link.

```
<a href="url">Download</a>
```

Presented as: Download, link.

#### Using screen reader text:

This is the preferred method and the method with the best SEO. 

```
<a href="url" target="\_blank">Register <span class="screen-reader-only">opens in a new window</span></a> 
```

Presented as: Register opens in a new window, link.

```
<a href="url">Read More <span class="screen-reader-only">about How to Train Your Dragon</span></a>
```

Presented as: Read more about How to Train Your Dragon, link.

```
<a href="url">View all <span class="screen-reader-only">blog posts</span></a>
```

Presented as: View all blog posts, link.

```
<a href="url">Download <span class="screen-reader-only">Website checklist</span></a>
```

Presented as: Download Website checklist, link.

#### Using aria-labelledby:

This method overrides the link content entirely, that is what is in-between the `<a>` tags will not be read to the user. This is typically perfectly accessible, though Google will identify that the link and the label are different and it will consider this a drawback when ranking the site.
```
<h2 id="heading">Register for Online Training</h2>
<a href="url" aria-labelledby="heading" target="\_blank">Register <span class="screen-reader-only">opens in a new window</span></a> 
```
Presented as: Register for Online Training, link.

Because aria-labelledby overrides the link, users will only be given the content from #heading and will miss the note about the link opening in a new window.
```
<h2 id="article">How To Train Your Dragon</h2>
<a href="url" aria-labelledby="article">Read More</a>
```
Presented as: How To Train Your Dragon, link.

This works very well in this case, and apart from the SEO hit is a decent solution.
```
<h2 id="recent">Recent Posts</h2>
<a href="url" aria-labelledby="recent">View all</a>
```
Presented as: Recent Posts, link.

In this case, the heading doesn’t accurately convey where that link takes the user so this wouldn’t be a great use of aria-labelledby.
```
<p id="pdf">Website Checklist</p>
<a href="url" aria-labelledby="pdf">Download</a>
```
Presented as: Website Checklist, link.

The problem here is it doesn’t tell the user that it’s a download anymore and they might experience confusion when the link doesn’t take them anywhere (browser behaviour depending).

#### Using aria-label:

This method also overrides the link content entirely, but does allow you to customize more than an aria-labelledby. Similarly to aria-labelledby, Google will identify that the link and the label are different and it will consider this a drawback when ranking the site.

You’ll notice in these examples we can add a little more context to our links that would normally be missed in the aria-labelledby method.
```
<a href="url" aria-label="Register for our online javascript training in a new window" target="\_blank">Register <span class="screen-reader-only">opens in a new window</span></a> 
```
Presented as: Register for our online javascript training in a new window, link.
```
<a href="url" aria-label="Read Article: How To Train Your Dragon">Read More</a>
```
Presented as: Read Article: How To Train Your Dragon, link.
```
<a href="url" aria-label="View all blog posts">View all</a>
```
Presented as: View all blog posts, link.
```
<a href="url" aria-label="Download our Website Checklist PDF">Download</a>
```
Presented as: Download our Website Checklist PDF, link.

---

### Linking Entire Content Cards

Linking an entire card is a common design in modern development, but it’s not without its challenges.

#### Wrap Everything in a Link:

This is the typical go-to method for developers for achieving this design requirement.
```
<a href="url">
   <img src="url" alt="A young man riding on a dark coloured dragon that has no teeth." >
   <h3>How to Train Your Dragon</h3>
   <p>The Viking village of Berk is frequently attacked by dragons, which steal livestock and endanger the villagers. Hiccup, the awkward 15-year-old son of the village chieftain, Stoick the Vast, is deemed too weak to fight the dragons.</p>
   <div>Read More</div>
</a>
```
Presented as: A young man riding on a dark coloured dragon that has no teeth, How to Train Your Dragon, The Viking village of Berk is frequently attacked by dragons, which steal livestock and endanger the villagers. Hiccup, the awkward 15-year-old son of the village chieftain, Stoick the Vast, is deemed too weak to fight the dragons, Read More, link."

That is a very wordy and unwieldy link name. Not ideal.

#### Using ARIA:

You could use an aria-labelledby instead to get something more concise and manageable by assistive technology.
```
<a href="url" aria-labelledby="title">
   <img src="url" alt="A young man riding on a dark coloured dragon that has no teeth." >
   <h3 id="title">How to Train Your Dragon</h3>
   <p>The Viking village of Berk is frequently attacked by dragons, which steal livestock and endanger the villagers. Hiccup, the awkward 15-year-old son of the village chieftain, Stoick the Vast, is deemed too weak to fight the dragons.</p>
   <div>Read More</div>
</a>
```
Presented as: How to Train Your Dragon, link.

But now the image alt and excerpt information are lost and inaccessible to assistive technology, being overridden by the aria-labelledby. Also, Google will take note that the link’s label and the link’s content are different, so we’ve also lost some SEO value.

#### Linking Each Part:

(Note: don't do this)

To avoid linking the entire card, it might make sense to link specific items like this:
```
<a href="url">
   <img src="url" alt="How To Train Your Dragon" >
   // If a link wraps an image, the image must include the link destination instead of a description of the image.
</a> 

<a href="url">
   <h3>How to Train Your Dragon</h3>
</a>

<p>The Viking village of Berk is frequently attacked by dragons, which steal livestock and endanger the villagers. Hiccup, the awkward 15-year-old son of the village chieftain, Stoick the Vast, is deemed too weak to fight the dragons.</p>

<a href="url" aria-label="How to Train Your Dragon">Read More</a>
```
Presented as: How to Train Your Dragon, link. How to Train Your Dragon, link. How to Train Your Dragon, link.

But now we’re giving our user redundant links, which isn’t a great experience either. 

#### Fake the Link:

(Note: don't do this)

It may be tempting to create a separate link and sit it overtop of the card with absolute positioning, which could solve the link text problem, however that introduces a new problem. One method for using assistive technology involves clicking on the content with a mouse to have it read aloud, which would be impossible if the content were covered with an invisible link.

#### Ideal Solution:

While this doesn’t meet the design fad of linking the entire card, it is perfectly usable by all and is recognized by Google as good practice. That means improved accessibility and improved SEO. 
```
<img src="url" alt="A young man riding on a dark coloured dragon that has no teeth." >
<h3>How to Train Your Dragon</h3>
<p>The Viking village of Berk is frequently attacked by dragons, which steal livestock and endanger the villagers. Hiccup, the awkward 15-year-old son of the village chieftain, Stoick the Vast, is deemed too weak to fight the dragons.</p>
<a href="url">Read More <span class="screen-reader-only">about How to Train Your Dragon</span></a>
```
Presented as: Read more about How to Train Your Dragon , link. 

In the event that the entire card linking is non-negotiable, consider the length of the link and the value of the content that would be lost using an aria-labelledby when deciding which route to go.

<h2 id="headings" class="anchor-heading">Headings {% include Util/link_anchor anchor="headings" %} {% include Util/top %}</h2>

To see the heading structure of any given website, submit a url to [WAVE](https://wave.webaim.org/) and view the Structure tab.

### Heading Guidelines:


#### Impacts SEO & Accessibility:

*   Every page must have an h1
    *   Even if it is hidden from view, there must be an h1 available to users of assistive technology.
*   There should only be one h1 on the page
    *   Multiple h1s means users of assistive technology have to guess which h1 describes the page purpose.
    *   Likewise, this presents multiple options to search engines which rely on the h1 to describe the page purpose.
*   The h1 should identify the purpose of the page
    *   Users and search engines should not have to guess what the page is about.
*   The h1 should match the page title
    *   The main exception to this is the homepage. Typically you would not have an h1 of "Home" (which would be seen in the page title) but rather an h1 that includes the name of the business or company. 
    *   "Power statements" sometimes get used here too, but it would be better to include a statement as a paragraph and provide a relevant h1 for screen readers.
*   Headings that are not followed by content are not appropriate as headings 
    *   Headings that are followed by sub headings are okay, provided the sub headings have content. But if you have two h2s in a row, or two h3s, etc, with no content in between, then those are not appropriate headings.

#### Impacts Accessibility:

*   Ideally, the h1 should be placed within the `<main>` landmark
    *   Someone who uses the bypass link to skip the heading should move into `<main>` and not skip the page heading as a result.
*   Do not use headings to achieve visual results
    *   Create mimic styles and utilize them to apply heading styles to different heading levels, divs, spans, etc.
*   Headings are meant to describe and organize the content that follows it
    *   If there isn't content to follow a heading, then it likely shouldn't be a heading. 
    *   Content should be related to the preceding heading. Assistive technology uses headings as a navigation tool.
*   Headings should help users find the content they want to consume
    *   Headings should make sense and offer value. "Best Recipe Ever" isn't as helpful as "Best Beef on a Bun Recipe Ever"
*   Headings should be sequential and denote content hierarchy 
    *   This is similar to a document outline. Each heading should follow the correct indentation based on the previously used heading and the content's place in the content hierarchy.

### Sequential Headings

Example (from [webaim](https://webaim.org/techniques/semanticstructure/#correctly)):

```
H1: My Favorite Recipes
        H2: Quick and Easy
                H3: Spaghetti
                H3: Hamburgers
                H3: Tacos
                        H4: Beef Tacos
                        H4: Chicken Tacos
                        H4: Fish Tacos
        H2: Some Assembly Required
                H3: Tuna Casserole
                H3: Lasagna
                        H4: Vegetable Lasagna
                        H4: Beef Lasagna
        H2: All-In
                H3: Crab-Stuffed Filet Mignon with Whiskey Peppercorn Sauce
                H3: Sun Dried Tomato and Pine Nut Stuffed Beef Tenderloin
```

You can see here the exact document structure based on the headings. The h2s are always followed by h3s or another h2, and h3s are always followed by h4s or return to h2 as the start of a new section. You should be able to make a similar outline with the headings on your page, both in structure and in content.

Also in the above example, a user could easily navigate to find a Chicken Taco recipe, or a Tuna Casserole. But if the heading isn’t followed by content, that would be nonsensical to users of assistive technology. "Beef Lasagna" should be followed by related content (in this case a recipe) and if it’s not, then it shouldn’t be a heading.

### Why Heading Structure Matters

In the provided screenshot, there’s an example of how a proper heading structure is presented to a user. In this manner, they can easily understand the relationships between content.

![A screen capture of an open rotor showing a list of sequential headings]({{ site.baseurl }}/img/a11y/rotor-headings-good.png)

Just from this I can tell there are 4 articles under "Keeping Up With the Latest".  There are 3 articles under "News and Commentary". "Our History" has a number of entries organized by year. Without the sequential heading structure there would be no way for a user to know how all of this content relates.

That's why Kanopi upholds this practice, even though sequential headings are a Level AAA item. The positive impact for users of assistive technology is significant.

Meanwhile in this second example, it is impossible to even tell what the website is for. The h1 is supposed to describe the purpose of the page, and even if by default we assumed the first h1 was the most important, it is merely a question mark. In fact, the name of this website doesn’t even appear until the 10th h1 - "Mighty Networks". This is a confusing mess.

![A screenshot of the screen reader rotor showing all the headings as level 1.]({{ site.baseurl }}/img/a11y/rotor-headings-bad.png)

Heading structure that skips levels (or misuses them) negatively impacts users of assistive technology, both in navigating the page and understanding the content.


<h2 id="cacher" class="anchor-heading">Cacher Examples
 {% include Util/link_anchor anchor="cacher" %} {% include Util/top %}</h2>

[Reduced Motion Animation](https://snippets.cacher.io/snippet/54d731586ef5272d7281)
