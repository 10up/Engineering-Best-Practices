<h2 id="performance-culture" class="anchor-heading">Performance Culture {% include Util/link_anchor anchor="performance-culture" %} {% include Util/top %}</h2>

At 10up, we understand that website performance is essential for a positive User Experience, Engineering, SEO, Revenue, and Design. It's not a task that can be postponed but rather a continuous and evolving process that requires strategic planning, thoughtful consideration, and extensive experience in creating high-quality websites.

10up engineers prioritize performance optimization when building solutions, using the latest best practices to ensure consistent and healthy performance metrics. We aim to develop innovative and dynamic solutions to reduce latency, bandwidth, and page load time.


<h2 id="core-web-vitals" class="anchor-heading">Core Web Vitals {% include Util/link_anchor anchor="core-web-vitals" %} {% include Util/top %}</h2>

At 10up, we pay close attention to Largest Contentful Paint, Cumulative Layout Shift, and First Input Delay. Collectively, these three metrics are known as Core Web Vitals.

We closely monitor Core Web Vitals during development to ensure a high-quality user experience. Maintaining healthy Web Vitals throughout the build and maintenance process is crucial, which requires a shift in building and supporting components. Achieving healthy Web Vitals requires a cross-disciplinary approach spanning Front-end engineering, Back-end engineering, Systems, Audience and Revenue, and Visual design.

<h3>Quick Links</h3>

1. [Optimising Images](#optimising-images)
2. [Optimising Rich Media](#optimising-rich-media)
3. [Optimising JavaScript](#optimising-javascript)
4. [Optimising CSS](#optimising-css)
5. [Optimising Fonts](#optimising-fonts)
6. [Optimising Resource Networking](#optimising-resource-networking)
7. [Optimising Third-party Scripts](#optimising-third-party-scripts)

<h3 id="optimising-images">1. Optimising Images {% include Util/link_anchor anchor="optimising-images" %}</h3>

_Images are typically the most significant resource on a webpage and can drastically affect load times. Therefore, optimizing images while maintaining quality to enhance user experience is crucial. To achieve this, consider the following aspects when working with website images. Combining all suggestions below can improve page load times and perceived performance._

<h4>1.1 Serve responsive images</h4>

Using [responsive images](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images) in web development means that the most suitable image size for the device or viewport will be served, which saves bandwidth and complements responsive web design. 
Many platforms, such as [WordPress](https://wordpress.org/) and [NextJS](https://nextjs.org/), provide responsive image markup out of the box using specific APIs or components. [Google Lighthouse](https://web.dev/serve-responsive-images/) will indicate if further optimization of your responsive images is necessary. You can also use the [Responsive Breakpoints Generator](https://www.responsivebreakpoints.com/) or [RespImageLint - Linter for Responsive Images](https://ausi.github.io/respimagelint/) to help you generate or debug responsive image sizes.


```html
<img
  alt="10up.com Logo"
  height="90px"
  srcset="ten-up-logo-480w.jpg 480w, ten-up-logo-800w.jpg 800w"
  sizes="(max-width: 600px) 480px,
         800px"
  src="ten-up-logo-800w.jpg"
  width="160px"
/>

```

<h4>1.2 Serve images from a CDN</h4>

Using a [Content Delivery Network (CDN)](https://developer.mozilla.org/en-US/docs/Glossary/CDN) to serve images can significantly enhance the loading speed of resources. Additionally, CDNs can provide optimized images using contemporary formats and compression techniques. Nowadays, CDNs are regarded as a fundamental element for optimizing performance. Here are some CDN suggestions with proven track records:

1. [Cloudinary](https://cloudinary.com/)
2. [Cloudflare](https://www.cloudflare.com/)
3. [Fastly](https://www.fastly.com/)
4. [WordPress VIP](https://docs.wpvip.com/technical-references/vip-platform/edge-cache/)

<h4>1.3 Serve images in modern formats</h4>

Efforts are currently focused on optimizing image compression algorithms to deliver high-quality, low-bandwidth images. Although several proposals have been made, only a few have been successful. [WebP](https://developer.mozilla.org/en-US/docs/Web/Media/Formats/Image_types#webp_image) is the most widely used contemporary format for this purpose.
When using a CDN, images can quickly be served as .webp by making a simple configuration change. The WordPress Performance Lab plugin has also added .webp functionality for uploads, which can be utilized if necessary.

Generally, it's recommended to use the .webp image format as much as possible in projects due to its performance benefits. Doing so can help pass the "[Serve images in modern formats](https://developer.chrome.com/en/docs/lighthouse/performance/uses-webp-images/)" audit in Google Lighthouse.

<h4>1.4 Lazy-load and decode images below the fold</h4>

We can use lazy loading for images to prioritize the rendering of critical above-the-fold content. This reduces the number of requests needed to render important content. Use the "[loading](https://developer.mozilla.org/en-US/docs/Web/Performance/Lazy_loading)" attribute on images to achieve this.

The "[decoding](https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/decoding)" attribute can enhance performance by enabling parallel image loading. WordPress Core offers this functionality by default.

```html
/* Above the Fold */
<img
  alt="10up.com Logo"
  decoding="sync"
  loading="eager"
  height="90px"
  src="ten-up-logo-800w.jpg"
  width="160px"
/>

/* Below the Fold */
<img
  alt="10up.com Logo"
  decoding="async"
  loading="lazy"
  height="90px"
  src="ten-up-logo-800w.jpg"
  width="160px"
/>

```

<h4>1.5 Use fetchpriority for LCP images</h4>

To improve your website's loading time, you’ll likely need to optimize the LCP element, which is typically the most prominent and first [image](https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/fetchPriority) on the page. Factors such as [First Contentful Paint](https://web.dev/fcp), [Time to First Byte](https://web.dev/ttfb/), and render-blocking CSS/JS can cause an image to be flagged as the LCP element. 

We can set a [fetch priority](https://addyosmani.com/blog/fetch-priority/) on the resource to load the image faster. The attribute hints to the browser that it should prioritize the fetch of the image relative to other images. The [Performance Lab plugin](http://g/plugins/performance-lab/) offers this functionality as a experimental option.

```html
<img
  alt="10up.com Logo"
  decoding="async"
  loading="eager"
  fetchpriority="high"
  height="90px"
  src="ten-up-logo-800w.jpg"
  width="160px"
/>

```
<h4>1.6 Ensure images have a width and height</h4>

Adding width and height attributes to all `<img />` elements on a page is essential to prevent CLS. If these attributes are missing, two problems can occur: 

1. the browser cannot reserve the correct space needed for the image,
2. the browser cannot calculate the aspect ratio of the image. 

This can also cause the [Properly size images](https://developer.chrome.com/en/docs/lighthouse/performance/uses-responsive-images/) audit Lighthouse to flag errors.

```html
<img
  alt="10up.com Logo"
  height="90px"
  src="ten-up-logo-800w.jpg"
  width="160px"
/>
```

<h4>1.7 Reduce image requests</h4>

Reducing the number of image requests a webpage makes is the best approach to improve image performance. This requires effective design and UX decisions. Additionally, using [SVGs](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/svg) instead of images for icons, decorative elements, animations, and other site elements can improve bandwidth and page load time.

Use tools like [SVGOMG](https://svgomg.net/) to optimize and minify SVG elements through build managers or manually in the browser where needed.

<h3 id="optimising-rich-media">2. Optimising Rich Media {% include Util/link_anchor anchor="optimising-rich-media" %}</h3>

<h4>2.1 Lazy-load iframes below the fold</h4>

To improve page loading speed, use the [loading="lazy"](https://developer.mozilla.org/en-US/docs/Web/Performance/Lazy_loading) attribute for rich media that use iframes, like [Youtube](https://www.youtube.com/), [Vimeo](https://vimeo.com/), or [Spotify](https://open.spotify.com/). This will delay the loading of assets until after the initial page load, which can save time and improve the user experience. 
Note: To lazy load the video and audio HTML5 elements, you’ll need to use either Load on Visibility or Load using the Facade Pattern.

<h4>2.2 Load using the Facade Pattern</h4>

To reduce the page load time, you can use the [Facade pattern](https://www.patterns.dev/posts/import-on-interaction) to render a low-cost preview of heavy and expensive assets, such as videos, and then import the actual asset when a user requests it. This technique enables loading the asset on demand while attempting to retain the overall user experience. 

Recently, this methodology has received a fair amount of attention; there are already packages that help achieve implementation for several services:

1. [Lite Youtube Embed](https://github.com/paulirish/lite-youtube-embed)
2. [Lite Vimeo Embed](https://github.com/luwes/lite-vimeo-embed)
3. [Intercom Chat Facade](https://github.com/danielbachhuber/intercom-facade/)

Follow [these instructions](https://gutenberg.10up.com/guides/modifying-the-markup-of-a-core-block/#youtube-embed-facade) to modify the core block output to support the facade pattern.

You can use the [script-loader snippet](https://gist.github.com/itsjavi/93cc837dd2213ec0636a) (outdated) to create a more general Facade mechanism. This snippet uses promises and can load necessary scripts when the user interacts with the user interface.

```js
const playBtn = document.querySelector("#play");

playBtn.addEventListener("click", () => {
  const scriptLoaderInit = new scriptLoader();
  scriptLoaderInit
     .load(["https://some-third-party-script.com/library.js"])
    .then(() => {
      console. log(`Script loaded!`);
    });
});
```

If your environment supports ES6 you can also use dynamic import:

```js
const btn = document.querySelector("button");
 
btn.addEventListener("click", (e) => {
  e.preventDefault();
  import("third-party.library")
    .then((module) => module.default)
    .then(executeFunction()) // use the imported dependency
    .catch((err) => {
      console.log(err);
    });
});
```

<h4>2.3 Load on Visibility</h4>

To load non-critical resources on demand, engineers can only load assets when they [become visible](https://www.patterns.dev/posts/import-on-visibility). The [Intersection Observer API](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API) can trigger a callback when elements become visible, enabling the selective loading of potentially heavy resources.

Read this [Smashing Magazine article](https://www.smashingmagazine.com/2018/01/deferring-lazy-loading-intersection-observer-api/) for an in-depth understanding of how the Observer APIs work. See the example code below for an idea of how to go about implementation:

```js
const images = document.querySelectorAll('.lazyload');

function handleIntersection(entries) {
  entries.map((entry) => {
    if (entry.isIntersecting) {
      entry.target.src = entry.target.dataset.src;
      entry.target.classList.add('loaded')
      observer.unobserve(entry.target);
    }
  });
}

const observer = new IntersectionObserver(handleIntersection);
images.forEach(image => observer.observe(image));
```

<h3 id="optimising-javascript">3. Optimising JavaScript {% include Util/link_anchor anchor="optimising-javascript" %}</h3>

_JavaScript files tend to be large and can block other resources from loading, slowing down page load times. Optimizing JavaScript without compromising its functionality is essential to enhance user experience and ensure a fast and responsive website._

<h4>3.1 Minify and compress payloads</h4>

To make your JavaScript code load faster and prevent it from blocking the rendering of your web page, it's important to minimize and compress the JavaScript payloads to reduce bandwidth usage. 10up Toolkit does this out-of-the-box using Webpack.

Files should also be [Gzip](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Encoding) or [Brotli](https://github.com/google/brotli) compressed. All major hosts already do this.

_Remember:_ *it's far more performant to load many smaller JS files than fewer larger JS files.*

<h4>3.2 Defer non-critical JavaScript</h4>

To provide an optimal user experience, it's crucial only to load critical JavaScript code during the initial page load. JavaScript that doesn't contribute to above-the-fold functionality should be deferred. 

Several approaches, outlined in sections 3.3 (Remove unused JavaScript code) and 3.4 (Leverage Code Splitting), can help achieve this. 
As an engineer, it's essential to determine what JavaScript is critical versus non-critical for each project. Generally, any JavaScript related to above-the-fold functionality is considered critical, but this may vary depending on the project.

The [script_loader_tag](https://developer.wordpress.org/reference/hooks/script_loader_tag/) filter allows you to extend [wp_enqueue_script](https://developer.wordpress.org/reference/functions/wp_enqueue_script/) to apply async or defer attributes on rendered script tags. This functionality can be found in [10up/wp-scaffold](https://github.com/10up/wp-scaffold/blob/trunk/themes/10up-theme/includes/core.php#L273).


<h4>3.3 Remove unused JavaScript code</h4>

To optimize the performance of your website, it's crucial to manage JavaScript bloat. Start by being mindful of what is requested during page load and the libraries and dependencies added to your JavaScript bundles.

First, remove unnecessary libraries and consider building custom solutions for required functionality instead of relying on bloated JS libraries that cover all edge cases.

Next, use the [Chrome Coverage tool](https://developer.chrome.com/docs/devtools/coverage/) to analyze the percentage of unused code within your bundles. This provides insights into how much code is being used.

Finally, leverage BundleAnalyzer tools to understand better what is bundled into your JavaScript payloads. This allows you to clearly understand your bundler's output, leading to more effective [code splitting](https://developer.mozilla.org/en-US/docs/Glossary/Code_splitting) and optimizing your website's performance.


<h4>3.4 Leverage code-splitting</h4>

Code splitting is a powerful technique that can significantly improve performance. It involves breaking JavaScript bundles into smaller chunks that can be loaded on demand or in parallel, especially as sites and applications scale. 

This is important because JavaScript affects Core Web Vitals, and code splitting can easily improve scores with minimal engineering effort. Tools like Webpack make it easy to set up code splitting, and [dynamic imports](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/import) further support its implementation. 

With code splitting, all chunks are lazy-loaded, reducing the likelihood of [long tasks](https://developer.mozilla.org/en-US/docs/Glossary/Long_task) and [render-blocking behavior](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceResourceTiming/renderBlockingStatus) and providing a streamlined implementation for better performance.

As an added benefit, if you know which chunks will be required on demand, you can [preload them](https://web.dev/preload-critical-assets) to be available sooner. To set up code splitting, you can use the Webpack [SplitChunksPlugin](https://webpack.js.org/plugins/split-chunks-plugin/).


<h4>3.5 Identify and flag long tasks</h4>

A long task refers to any JavaScript task on the main thread that takes longer than 50ms to execute. Long tasks are problematic as they block the main thread, preventing it from moving on to its next task in the pipeline and negatively impacting performance.

To improve performance, engineers must find ways to break up long tasks and prevent them from blocking the main thread. However, this can be challenging, especially when dealing with third-party vendor code that cannot be optimized directly.

This underscores the importance of practicing effective task management to mitigate the impact of long tasks on performance. The subject of task management is complex and requires an in-depth understanding of JavaScript and browser mechanics. 

However, you can look into the following strategies if your code is causing long task behavior:

1. _Use setTimeOut_: leverage [setTimeOut](https://developer.mozilla.org/en-US/docs/Web/API/setTimeout) to yield to the main thread. [See example](https://web.dev/optimize-long-tasks/#manually-defer-code-execution).
2. _Use async/await_: you can use [async/await](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function) to yield to the main thread. [See example](https://web.dev/optimize-long-tasks/#use-asyncawait-to-create-yield-points).
3. _Use isInputPending_: this [method](https://web.dev/isinputpending/) allows you to yield to the main thread if the user interacts with the page. [See example](https://web.dev/optimize-long-tasks/#yield-only-when-necessary).
4. _Use postTask_: The [Scheduler API](https://developer.mozilla.org/en-US/docs/Web/API/Scheduler/postTask) allows you to set a priority on functions. It's only supported in Chrome now but provides fine-grained control over how and when tasks execute on the main thread. [See example](https://web.dev/optimize-long-tasks/#a-dedicated-scheduler-api).

<h3 id="optimising-css">4. Optimising CSS {% include Util/link_anchor anchor="optimising-css" %}</h3>

_Large and complex CSS files can slow page load times and affect interactivity. Optimizing CSS without sacrificing design quality is essential to ensure a fast and responsive website._

<h4>4.1 Minify CSS</h4>

[Minifying CSS](https://web.dev/minify-css/) is a common practice that reduces data transfer between the server and browser. Since modern web pages have a lot of CSS, compressing them is crucial to reduce bandwidth consumption. 

Use build tools like [Webpack](https://webpack.js.org/) or CDNs with query string parameters to minify CSS. Smaller CSS files can speed up download times and reduce render-blocking activity in the browser. [10up Toolkit](https://github.com/10up/10up-toolkit) does all this out of the box.

<h4>4.2 Leverage Purge CSS</h4>

[Purge CSS](https://purgecss.com/) optimises the browser rendering pipeline and prioritize critical resources. PurgeCSS is a library that minimizes unused CSS on a web page. It analyzes your content and CSS files, matches the selectors used in your files with the ones in your content files, and removes unused selectors from your CSS. 

This results in smaller CSS files, but it may not work for dynamic class name values that can change at build time. If you have primarily static CSS on your site, PurgeCSS is an excellent tool.At any time, you can leverage the [Code Coverage](https://developer.chrome.com/docs/devtools/css/reference/#coverage) tool in Google Chrome to determine how much of your CSS is unused. 

<h4>4.3 Avoid render-blocking CSS</h4>

[Render-blocking CSS](https://developer.mozilla.org/en-US/docs/Web/Performance/Critical_rendering_path) is a significant performance issue that engineers must tackle to ensure a positive user experience. Not all CSS required for the page should be loaded during the initial load. Some can be deferred or prioritized, depending on the use case. There are various ways to solve render-blocking CSS on a webpage, each with its caveats and variability. Here are some potential options:

1. Embed critical and anticipated CSS using `<style>` tags. This can be a performant way to improve user experience. You may want to place CSS related to fonts, globals, or elements that appear above the fold so that the browser renders them faster.
2. Use the [Asynchronous CSS Technique](https://gomakethings.com/how-to-load-css-asynchronously/) to defer non-critical CSS. Only use this for CSS that may appear below the fold. 

```html
<link
 rel="preload"
 href="styles.css"
 as="style"
 onload="this.onload=null;this.rel='stylesheet'"
>
<noscript><link rel="stylesheet" href="styles.css"></noscript>
```
If you would like to identify and debug render-blocking CSS and JS you can toggle on [ct.css](https://csswizardry.com/ct/) in [10up/wp-scaffold](https://github.com/10up/wp-scaffold). By appending `?debug_perf=1` to any URL in your theme, all render-blocking assets in the head will be highlighted on the screen.

<h4>4.4 Adhere to CSS Best Practices</h4>

How we [write CSS](https://www.youtube.com/watch?v=nWcexTnvIKI) can significantly affect how quickly the browser parses the [CSSOM](https://developer.mozilla.org/en-US/docs/Web/API/CSS_Object_Model) and [DOM](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model/Introduction). The more complex the rule, the longer it takes the browser to calculate how it should be applied. Clean and optimized CSS rules that are not overly specific can help deliver a great user experience.

When writing performant CSS, there are certain guidelines to consider to ensure optimal performance. Here are some of the most important ones:

1. Avoid importing base64 encoded images: this dramatically increases the file size of your CSS.
2. Avoid importing one CSS file into another CSS file using @import: this can trigger knock network requests and lead to latency.
3. Be cautious when animating elements, and avoid overusing them without careful consideration.
3. Avoid animating or transitioning margin, padding, width, and height properties.
5. Be mindful of elements that trigger a [re-paint](https://css-tricks.com/browser-painting-and-considerations-for-web-performance/) and [reflow](https://developers.google.com/speed/docs/insights/browser-reflow).

Use [CSS Triggers](https://csstriggers.com/) to determine which properties affect the [Browser Rendering Pipeline](https://web.dev/rendering-performance/).

<h3 id="optimising-fonts">5. Optimising Fonts {% include Util/link_anchor anchor="optimising-fonts" %}</h3>

_Loading multiple or large font files can increase page load times and affect overall site performance. Optimizing fonts while maintaining design integrity is essential for a fast and responsive website._

<h4>5.1 Always set a font-display</h4>

Choosing the right [font-display](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/font-display) property can significantly affect how fast fonts are [rendered](https://web.dev/optimize-webfont-loading/). To get the fastest loading time, it's recommended to use [font-display: swap](https://css-tricks.com/almanac/properties/f/font-display/) since it blocks the rendering process for the shortest amount of time compared to other options.  

```css
@font-face {
  font-family: 'WebFont';
  font-display: swap;
  src:  url('myfont.woff2') format('woff2'),
        url('myfont.woff') format('woff');
}

```

Note: For [TypeKit](https://fonts.adobe.com/fonts), the font-display setting can be configured on the type settings page. For [Google Fonts](https://fonts.google.com/), you can append &display=swap to the end of the URL of the font resource.

<h4>5.2 Preconnect and serve fonts from a CDN</h4>

Font foundries like Google Fonts and TypeKit use CDNs to serve fonts. This speeds up load times and allows font files and CSS to be delivered to the browser faster. Since fonts are essential to the rendering process, ensuring the browser can fetch them early is crucial. 
To do this, preconnect to the necessary origins and use dns-prefetch as a fallback for older browsers:

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="dns-prefetch" href="https://fonts.googleapis.com" crossorigin>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="dns-prefetch" href="https://fonts.gstatic.com" crossorigin>
```
<h4>5.3 Serve fonts locally</h4>

To achieve fast font rendering, serving fonts locally can be very effective. This can be done using the CSS [@font-face](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face) declaration to specify a custom font using a local path. The browser will first check if the font exists on the user's operating system, and if it does, it will use the local version. This is the quickest way to serve a font - but only if the user has it installed.

```css
@font-face {
  font-family: 'WebFont';
  font-display: swap;
  src:  local('myfont.woff2'),
        url('myfont.woff2') format('woff2'),
        url('myfont.woff') format('woff');
}

```

<h4>5.4 Subset fonts</h4>

Subsetting is a valuable technique for reducing the font size. When we add fonts to a site, we sometimes include subsets containing glyphs for languages that have yet to be used. This unnecessarily increases page load times. 
However, the @font-face [unicode-range descriptor](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/unicode-range) can be used to filter out unnecessary glyph ranges based on the specific requirements of your website.

```css
@font-face {
  font-family: 'WebFont';
  font-display: swap;
  src:  local('myfont.woff2'),
        url('myfont.woff2') format('woff2'),
        url('myfont.woff') format('woff');
  unicode-range: U+0025-00FF;
}

```

<h4>5.5 Leverage size-adjust</h4>

To reduce the impact of Cumulative Layout Shift (CLS) on web pages, the [size-adjust](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/size-adjust) property can be helpful. It helps [normalize document font sizes and prevents layout shifts](https://web.dev/css-size-adjust/) when switching fonts. This is especially important on slow connections, where a fallback font is initially rendered before the desired font is loaded. 

```css
// Desired Font
@font-face {
  font-family: 'WebFont';
  font-display: swap;
  src:  local('myfont.woff2'),
        url('myfont.woff2') format('woff2'),
        url('myfont.woff') format('woff');
}

// Fallback
@font-face {
  font-family: 'Arial';
  src:  local('Arial.woff2');
  font-family: 90%;
}

```

<h4>5.6 Font Delivery Considerations</h4>

When loading fonts, there are a few other things to keep in mind:

1. Use [WOFF](https://developer.mozilla.org/en-US/docs/Web/Guide/WOFF) or [WOFF2](https://www.w3.org/TR/WOFF2/) formats instead of [EOT](https://www.w3.org/Submission/EOT/#:~:text=The%20Embedded%20OpenType%20File%20Format,the%20font%20the%20author%20desired.) and [TTF](https://en.wikipedia.org/wiki/TrueType), as the latter is no longer necessary.
2. Load fewer web fonts whenever possible. Where possible, use a maximum of 2 fonts. 
3. Consider using [variable fonts](https://fonts.google.com/knowledge/introducing_type/introducing_variable_fonts) if your site requires many font weights or styles.

<h3 id="optimising-resource-networking">6. Optimising Resource Networking {% include Util/link_anchor anchor="optimising-resource-networking" %}</h3>

_Poorly optimized resource networking can lead to slow page load times and a poor user experience. To improve Core Web Vital's performance, maximizing resource networking is crucial by minimizing the number of requests made, reducing the file size of resources, and utilizing browser caching._

<h4>6.1 Use a CDN for static assets</h4>

In section 1.2, "Serve images from a CDN," it was mentioned that using a CDN can help deliver more than just images. It can also serve CSS, JS, Fonts, and Rich Media from nearby global data centers. 

To reduce latency and round trips through DNS servers, serve all static assets over a CDN as much as possible. Additionally, you can establish an early connection to the CDN origin by [pre-connecting](https://developer.chrome.com/en/docs/lighthouse/performance/uses-rel-preconnect/) to ensure faster page load times.

<h4>6.2 Establish network connectivity early</h4>

To establish an early connection and improve the loading speed of resources critical to above-the-fold content rendering and interactivity, add the appropriate `<link rel="preconnect" />` tag to the `<head>`. 

By placing the tag in the `<head>`, the browser is notified to establish a connection as soon as possible. This approach, also called [Resource Hints](https://developer.mozilla.org/en-US/docs/Web/HTTP/Client_hints), can speed up resource times by 100-500ms. It's crucial, however, to only preconnect to some third-party origins on a page. Only preconnect to origins essential for the start and completion of page rendering.

Some examples of origins you may want to connect to are:

- CDNs
- Critical 3rd-party scripts that manipulate the DOM above the fold.
- Consent Management libraries, e.g., OneTrust
- Ad or tag scripts like Google Publisher Tag or Google Tag Manager.

<h4>6.3 Prioritise and preload critical resources</h4>

Browsers try to prioritize scripts and resources as best as possible, but sometimes human intervention is needed. Engineers can influence the browser's decisions using specific attributes and hints.

You can view the assigned priority for each resource in the [Chrome Dev Tools Network tab](https://developer.chrome.com/docs/devtools/network/). The browser has three solutions for influencing priorities.

1. preconnect - which hints to the browser that you’d like to establish a connection with another origin early.
2. prefetch - hints to the browser that something should happen with a non-critical resource.
3. preload - allows you to request critical resources ahead of time.

Here are three scenarios where it would make the most sense to implement the `<link rel="preload" />` tag:

1. Any resource defined in a CSS file, i.e., an image or font, should be preloaded.
2. Any non-critical CSS should be preloaded to mitigate render-blocking JavaScript if implementing Critical CSS.
3. Preloading critical JavaScript chunk files.

Add a `<link />` tag in the `<head>` to preload a resource. The as attribute tells the browser how best to set the resource's prioritization, headers, and cache status.

```html
<link rel="preload" as="style" href="/path/to/resource" />
```

<h4>6.4 Optimise TTFB (Server Response)</h4>

Although TTFB (Time to First Byte) is not classified as a Core Web Vital, it is a critical indicator of site speed. TTFB is the first metric before every other measurable metric regarding web performance. If your TTFB is extremely slow, it will impact FCP and LCP.

Achieving the lowest possible TTFB value is essential to ensure that the client-side markup can start rendering as quickly as possible. To improve TTFB, you need to focus less on the client side and more on what occurs before the browser begins to paint content. Factors to consider include:

- hosting,
- platform-specific guidance (such as WordPress or NextJS),
- the use of a CDN (Content Delivery Network), 
- and the number of redirects.

It's highly advisable to leverage a strategic caching strategy in order to optimize Time to First Byte. Suggested caching strategies are documented in the [PHP Performance Best Practices](https://10up.github.io/Engineering-Best-Practices/php/#performance).  

You can read more about [Optimizing TTFB](https://web.dev/optimize-ttfb/) on [web.dev](https://web.dev/).

<h4>6.5 Leverage Adaptive Serving</h4>

You can use adaptive serving to help improve performance when network conditions are poor. This functionality can be implemented using the Network Information API to return data about the current network.

Adaptive serving allows you to decide on behalf of the user to handle circumstances like:

1. Serving high-definition vs. low-definition resources
2. Whether or not to preload certain resources
3. Warn users about poor network conditions to improve user experience.
4. Send data to analytics to determine what percentage of your traffic uses your website under poor connectivity scenarios.

```js
navigator.connection.addEventListener("change", () => {
   sendBeacon(); // Send to Analytics
   if (navigator.connection.effectiveType === "2g" ) {
     body.classList.add("low-data-mode") 
   }
});
```

<h3 id="optimising-third-party-scripts">7. Optimising Third-party Scripts {% include Util/link_anchor anchor="optimising-third-party-scripts" %}</h3>

_Third-party scripts can significantly impact website performance and negatively affect Core Web Vitals metrics. Optimizing and managing third-party scripts is essential to ensure they don't negatively impact user experience._

<h4>7.1 Identify slow third-party scripts</h4>

The best way to flag slow-performing third-party scripts is to use three Chrome DevTools features: [Lighthouse](https://developer.chrome.com/docs/lighthouse/overview/), [Network Request Blocking](https://developer.chrome.com/docs/devtools/network/), and the [Coverage tool](https://developer.chrome.com/docs/devtools/coverage/).

Two audits will fail if you have third-party scripts causing performance to degrade:

1. [Reduce JavaScript execution time](https://developer.chrome.com/docs/lighthouse/performance/bootup-time/): highlights scripts that take a long time to parse, compile, or evaluate.
2. [Avoid enormous network payloads](https://developer.chrome.com/docs/lighthouse/performance/total-byte-weight/): identifies network requests—including those from third parties—that may slow down page load time.

To get more information on third-party scripts' impact on performance, you can check the [Third-party usage report](https://developer.chrome.com/docs/lighthouse/performance/third-party-summary/) generated after Lighthouse finishes auditing the site. You can also use the Coverage tool to identify scripts that load on the page but are mostly unused.

To demonstrate the impact of third-party scripts, you can use Chrome's Network Request Blocking feature to prevent them from loading on the page. After blocking them, run a Lighthouse audit on the page to see the performance improvement. 

Follow the [instructions provided](https://developer.chrome.com/docs/devtools/network/#block) to use this feature.

<h4>7.2 Prioritize critical third-party scripts</h4>

To optimize the critical rendering path, prioritize loading third-party scripts essential for rendering a valuable and interactive page experience above the fold content. 

Only load a minimal amount of critical JavaScript during the initial page load. Defer any non-critical scripts until after the page load. 
Note that third-party scripts running JavaScript have the potential to obstruct the main thread, causing delays in page load if not fetched, parsed, compiled, and evaluated properly. As an engineer, you must decide which scripts to postpone.

Usually, deferring interactive chat or social media embed scripts will see performance benefits. Ad-tech and cookie consent libraries are unsuitable for this approach and should be loaded immediately.


<h4>7.3 Lazy-load scripts on interaction</h4>

It's also possible to load third-party scripts (depending on the use case) on UI interaction. You can follow the guidance provided in 2.3 Load using the Facade Pattern or 2.4 Load on Visibility for details on achieving that functionality.  


<h4>7.4 Leverage service workers</h4>

Using a [service worker](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) is one way to cache scripts and improve performance, but there are some critical considerations. Setting up a service worker can be challenging, and your site must use HTTPS. Additionally, the resource you are caching must support [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS). If it does not, you will need to use a [proxy server](https://en.wikipedia.org/wiki/Proxy_server). 

Use [Google's Workbox](https://developer.chrome.com/docs/workbox/) solution for implementing caching strategies with service workers. Service workers can cache static assets such as fonts, JS, CSS, and images. The service worker may not fetch the latest version if you are caching scripts that update frequently. In this instance, you must account for that using a [network-first](https://developer.chrome.com/docs/workbox/caching-strategies-overview/) approach.


<h4>7.5 Tag Manager implications</h4>

Google Tag Manager (GTM) is a commonly used tool for implementing tags and third-party snippets. While the GTM script is not always an issue, the amount of third-party code it injects can significantly impact performance. 

In general, the impact on performance based on tag type is as follows: image tags (pixels), custom templates, and custom HTML. If you inject a vendor tag, the impact will depend on the functionality they add to the site. 

Do inject scripts with any visual or functional side effects during page load. Custom HTML tags get injected into the DOM and can cause unexpected issues. Avoid using Custom HTML that forces the browser to recalculate the layout or could trigger a layout shift. 

Injecting scripts can also negatively impact performance. Inject all scripts via a Tag Manager before the closing body tag instead of the `<head>`. Triggers, custom events, and variables add extra code to the parsing and evaluation of the tag manager script.

Loading the tag manager script appropriately is essential to fire triggers and events properly. Loading the script later in the DOM can help with this. It's also important to periodically audit the container to ensure no duplicated or unused tags and to keep it up-to-date with current business requirements.


<h4>7.6 Ad Script Best Practices</h4>

Ad technologies can generate significant revenue for publishing clients, making it crucial to optimize for performance. However, complex ad implementations can negatively impact performance, primarily when ad configurations fire during the initial page load. 

Implementing ad configurations requires an in-depth understanding of ad exchanges and scripts. Here are high-level guidelines to effectively implement ads on publisher sites:

1. To minimize CLS, ensure space is reserved for ad units above the fold. Follow [Google's recommendation](https://developers.google.com/publisher-tag/guides/minimize-layout-shift) to determine the most frequently served ad unit in a slot and set the height of the reserved space accordingly.
2. Load the ad script in the `<head>` as early as possible to ensure the browser parses and executes it promptly. To further improve this, you can [preload](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/rel/preload) the ad script so that it's available to the browser sooner.
3. Ensure that the ad script is loaded asynchronously. This can be achieved by placing the async="true" attribute on the script. This allows the browser to fetch the resource while parsing and evaluating the script.
4. Always load the script statically: place the evaluated script in the `<head>`. Never build the script asynchronously using the [createElement API](https://developer.mozilla.org/en-US/docs/Web/API/Document/createElement). This can lead to latency issues and delayed execution of ad calls.
5. The most important consideration for ensuring performant ad implementations is a healthy page experience. An optimized [critical rendering path](https://developer.mozilla.org/en-US/docs/Web/Performance/Critical_rendering_path) and low FCP and TTFB can improve ad performance. 
