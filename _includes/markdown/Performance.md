<h2 id="philosophy" class="anchor-heading">Philosophy {% include Util/link_anchor anchor="philosophy" %} {% include Util/top %}</h2>

At 10up, we understand the importance of performance in delivering a great user experience and ensuring that content is optimized for search engine rankings. As the web and application development has evolved, feature rich content can be problematic and slow to load, particularly on mobile devices. It is more important than ever to pay careful consideration towards performance when designing and engineering solutions.

There are multiple factors to take into account when considering performance on a project. Third party embeds or scripts can often have a negative impact on performance, but in some cases the inherent value that they bring may justify the performance impact incurred.

__While performance is always important, actual needs vary by website. For example, an internal company tool might not place as much importance on it as an online store. As such, 10up has developed these baseline performance best practices to be implemented on all our projects. On some projects more will be done for performance, but we strive to achieve this baseline no matter what. Also worth mentioning is we don't have any sort of standard "numbers" e.g. core web vitals, PSI score, or TTFB. This is because there is no one number that can apply to all websites.__

<h2 id="baseline" class="anchor-heading">Baseline Performance Best Practices {% include Util/link_anchor anchor="baseline" %} {% include Util/top %}</h2>

### Caching

Caching is a key aspect in reaching optimal performance both from a server and browser optimisation perspective, below are caching approaches:

*   Ensure all static assets have cache busters in the form of either a version or fingerprint in the filename or unique query string in the URL. This needs to be implemented along with a cache-control header max-age of at least 1 month but optimally 1 year.
*   A CDN is highly recommended, most popular CDN’s may offer page caching, browser caching and image optimizations.
*   [Page caching](https://10up.github.io/Engineering-Best-Practices/php/#page-caching) should be set up, a lot of common hosting companies including WP Engine and WordPress VIP offer full page caching.
*   [Object caching](https://10up.github.io/Engineering-Best-Practices/php/#the-object-cache) should be leveraged where applicable on the server.
*   All projects should have a [manifest file](https://web.dev/add-manifest/) to download static assets that will be rarely updated. The [manifest.json is included in 10ups WP Scaffold](https://github.com/10up/wp-scaffold/blob/trunk/themes/10up-theme/manifest.json) and will require custom configuration.

### Images and Media

*   Images should be optimized for Next-Gen formats. JPEG 2000, JPEG XR, and [WebP](https://developers.google.com/speed/webp) are image formats that have superior compression and quality characteristics compared to their older JPEG and PNG counterparts.
*   Crop images appropriately, you do not need to create a crop for every size but in some cases a few extra crops to handle mobile proportions can be useful.
*   Images should be served using srcset so that smaller sizes can be shown for smaller viewports.
*   All images implemented through code should [contain a width and height attribute](https://web.dev/optimize-cls/#images-without-dimensions). This is especially important in avoiding Content Layout Shift issues.
*   Assets in particular images, should be served through a CDN.
*   Images, Videos and iFrames should be lazy loaded. Please note that [WordPress will handle browser level lazy loading](https://make.wordpress.org/core/2021/02/19/lazy-loading-iframes-in-5-7/) using [native lazy load](https://web.dev/native-lazy-loading/). In order for this to take effect, the width and height should be set on the tag.
* If you're not seeing performance benefits by lazy-loading IFrames, look into using the [Facade Pattern](https://web.dev/third-party-facades/)
* Hosting videos directly on WordPress should be avoided and can be problematic at scale. 10up recommends a dedicated hosting service such as Brightcove, Vimeo, YouTube, Dailymotion, etc.

### Fonts

*   Fonts used across the site should be [preloaded](https://web.dev/codelab-preload-web-fonts/).
*   Whenever available, WOFF2 font formats should be used for better compression with a WOFF fallback.
*   Subset Font files if you have them available locally.
*   Investigate using `unicode-range` to subset fonts if they are being served locally or through [Google Fonts](https://developers.google.com/fonts/docs/getting_started#specifying_script_subsets).
*   Fonts should either be served locally or from a single foundry (don’t mix Google fonts and TypeKit, pick one).

### JavaScript and CSS

*   Write JavaScript and CSS with the "Mobile First" approach in mind.
*   Ensure that JavaScript and CSS are not [render-blocking](https://web.dev/render-blocking-resources/). Sometimes external plugins and libraries add render blocking scripts that we cannot remove easily. In those cases, we can make exceptions and add todos to remediate later if time permits.
*   All JavaScript and CSS should be minified.
*   Standalone site features should be broken off into isolated entry points so we don’t have to load more CSS/JS on pages that will never use it.
*   Be aware of any additional requests 3rd-party libraries are making on page load. This can serverly impact performance scores.
*   Where possible, defer loading of libraries that are not neccessary for a stable user experience until after initial load.
*   Critical rendering path should be considered. Scripts should be loaded in the footer and external scripts should contain the [‘async’ attribute](https://www.w3schools.com/tags/att_script_async.asp) or be loaded at the bottom of the document where they can’t be concatenated into a single file. Internal scripts without an implicit loading order should contain the [‘defer’ attribute](https://www.w3schools.com/tags/att_script_defer.asp) if possible. Note that scripts using the ‘defer’ attribute can be loaded in the head tag as they will be fetched asynchronously while being executed after the HTML is parsed.

### Design and UX

As part of design reviews, engineering teams should provide feedback on the following:

*   Avoid using large media objects for decorative purposes if no business value is present. If large media objects are used, consider only loading them on larger screen sizes.
*   Avoid structural page changes based on the browser width as they require extra scripting and can slow performance.
*   Err on the side of typefaces that offer WOFF2 font files, as they are quicker to load.
*   Avoid auto playing videos, particularly above the fold and on mobile screens.

### Advertising

*   All ads should be lazy loaded.
*   Keep ads above the fold to a minimum.

### Systems

*   Use HTTP/2 enabled hosting whenever possible.
*   GZIP compression should be active.

[Read more on the 10up systems performance best practices.](https://10up.github.io/Engineering-Best-Practices/systems/#performance)

### Third Party Plugins and Scripts

*   Third party plugins can play a part in poor site performance. Always audit a plugin for performance issues before adding it to a project. Paying careful attention to the server side impacts of slow non-cached queries and how data is being stored to the weight of the JavaScript and CSS being included on every page.
*   Third party scripts, particularly those being loaded for the purpose of analytics, embeds, helper libraries and advertising can have a major impact on site performance. Oftentimes, these scripts may be loaded through Google Tag Manager rather than directly in the page using script tags making it difficult to anticipate the impact on a project. Ensure that site performance is being tested ahead of any launch with all third party scripts loaded. If any scripts result in a negative impact on performance, ensure to flag this with your team.

__Note__: When starting a new project or inheriting an existing one, take before screenshots of the Google PSI report so performance can be compared before-and-after.

<h2 id="core-web-vitals" class="anchor-heading">Core Web Vitals {% include Util/link_anchor anchor="core-web-vitals" %} {% include Util/top %}</h2>
[Web Vitals](https://web.dev/vitals/), a performance initiative by Google, provides us a set of rules, concepts and metrics in order to serve users with the best web experience possible. Performance measuring in the past has often landed in the domain of engineers. However with the introduction of Web Vitals, site owners can now gain an understanding of the performance impacts and shortcomings of their sites without a deep understanding of web technologies. Web Vitals aim to simplify understanding and provide pertinent guidance to site owners and engineers alike in order to optimize user experience.

At 10up, we closely monitor [Core Web Vitals](https://web.dev/vitals/#core-web-vitals) (a subset of Web Vitals) during development which was introduced in June 2021 into Googles ranking algorithm. Ensuring healthy Web Vitals through out build and/or maintenance is of paramount importance and requires a shift not only in how we go about building components, but in maintaining a high level of quality across overall user experience.

### Cross Discipline Approach
At 10up we acknowledge that achieving healthy Web Vitals across the board is not siloed to one discipline. Ensuring healthy Web Vitals requires a cross discipline approach spanning Front-end Engineering, Web Engineering, Systems, Audience and Revenue and Visual Design.

As defined by Google, the 3 Core Web Vitals are currently:

* [Largest Contentful Paint (a.k.a. LCP)](https://web.dev/lcp/)
* [Cumulative Layout Shift (a.k.a. CLS)](https://web.dev/cls/)
* [First Input Delay (a.k.a. FIP)](https://web.dev/fid/)

### Largest Contentful Paint
Largest Contentful Paint is an important metric for measuring perceived user performance, specifically *loading performance*.
This metric reports the render time of the largest element on the page _that is visible to the user_.

> An LCP score of 2.5 seconds or less is considered to be a conducive measurement for good user experience.

LCP is measured in seconds (s) and can be tracked against the following DOM elements:

* `<img>`
* `<image>` - inside an SVG
* `<video>`
* An element with a `background-image`
* Any element that is considered to be block-level (`display: block`)

#### How to diagnose Largest Contentful Paint
The quickest way to diagnose the Largest Contentful Paint element on the page is by following these steps:

1. Open _Google Chrome_
2. Open _Chrome DevTools_
3. Select the _Performance_ Tab
4. Check the _Web Vitals_ checkbox
5. Click the _Reload_ button or hit `⌘ ⇧ E` shortcut
6. Scroll down to _Timings_
7. Select the green _LCP_ marker
8. In _Summary_ scroll down to "Related Node"
9. Click the _node_ listed and it will be highlighted in the _DOM_.

#### How to fix Largest Contentful Paint

Once you have diagnosed which element on the page has the Largest Contentful Paint, the next step is to figure out why.
There are 3 main factors that contribute to LCP:

1. Slow server response times.
2. Render-blocking JavaScript and CSS.
3. Resource load times.

It's important that your server is optimized in a way that doesn't have a domino effect on other vitals.
To measure the "speed" of your server you can track the [Time to First Byte (TTFB)](https://web.dev/time-to-first-byte) vital.

Here are some high-level guidelines for ensuring Largest Contentful Paint occurs as fast as possible:

* Serve assets (Images, JavaScript, CSS, Video) over a CDN.
* Ensure that there is a well-thought out caching strategy in place.
* Use `<link rel="preconnect">` and `<link rel="dns-prefetch">` for assets that originate at third-party domains.
* Ensure that scripts and styles are carefully audited to ensure that there are no render-blocking patterns in order to improve First Contentful Paint, which will consequently improve Largest Contentful Paint.
* Ensure that your CSS bundles are minified (see [Task Runners](https://10up.github.io/Engineering-Best-Practices/tools/#task-runners)) and deferred if the CSS rules do not apply above the fold. You can also use Chromes "Coverage" tab to identify just how much of your CSS bundle is being utilized on the page.
* Ensure that your JS bundles are minified, compressed and if the functionality is not required above-the-fold, lazy-loaded.

The time it takes the browser to fetch resources like images or videos can also have an effect on LCP:
* Optimize and compress all images on the site - ensure images are not greater than twice their contained real-estate.
* Make sure that images are being served over a CDN, you're serving formats like WebP or AVIF and you're using responsive images techniques.
* For images that find themselves in Hero components, `preload` the image resource ahead of time. For [responsive images](https://web.dev/preload-responsive-images/) you will need to add the `imagesrcset` and `imagesizes` attributes: `<link rel="preload" as="image" imagesrcset=" image-400.jpg 400w, image-800.jpg 800w, image-1600.jpg 1600w" imagesizes="100vw" />`.
* Check with Systems or Web Engineering that the server is utilizing compression algorithms like Gzip or Brotli.

### Cumulative Layout Shift

Cumulative Layout Shift measures the *visual stability* of a web page.
CLS can be an elusive metric to get right as elements targeted as having a layout shift are often not the root cause. By ensuring
limited layout shifts on the page, visitors will be presented with a smooth and delightful user experience.

> A CLS score of 0.1 or less is considered to be a conducive measurement for good user experience.

Its important to understand that the CLS metric does not just measure one offending element. The CLS score reported is the sum total of all layout shifts on the page. A layout shift occurs any time a visible element (i.e above the fold), changes its position from one rendered frame to the next.

To be clear, a layout shift is only considered a problem if it's *unexpected* - so a shift in an elements position that was triggered on purpose by a user is acceptable.

Its useful to know that a layout shift can be caused by the following events:
* A change in the position of a DOM element
* A change in size of the dimensions of a DOM element
* Inserting or removing DOM elements through JavaScript
* CSS / JS animations that would trigger Reflow (recalculation of layout)

Considering the above, it would be plausible that nearby DOM elements could then change their position and dimensions based on another elements movement.

#### How to diagnose Cumulative Layout Shift

The quickest way to diagnose an element that has undergone a layout shift is by following these steps:

1. Open _Google Chrome_
2. Open _Chrome DevTools_
3. Select the _Performance_ Tab
4. Check the _Web Vitals_ checkbox
5. Click the _Reload_ button or hit `⌘ ⇧ E` shortcut
6. Scroll down to _Experience_
7. If there is a Layout Shift on the page, Chrome will add a red bar with "Layout Shift" as the label.
8. In _Summary_ scroll down to the "Moved from" / "Moved to" section.
9. Hover over each "Location" / "Size" label and Chrome will highlight the offending element on the page.

As an alternative, you can also diagnose Layout Shifts on the page by:

1. Open _Google Chrome_
2. Open _Chrome DevTools_
3. Hit `⌘ ⇧ P` to open the actions console.
4. Start typing "Rendering" until the prompt suggests: "Show Rendering", hit Enter.
5. A dialog will appear at the bottom of the DevTools window.
6. Check "Layout Shift Regions" and refresh the page.
7. All elements that have been identified as triggering a layout shift will be highlighted.

#### How to fix Cumulative Layout Shift

Elements that cause CLS can be easily fixed in some instances. As a general rule of thumb ensure that:

* All images loaded on the site have a `width` and a `height` attribute. This is because HTML gets parsed before CSS and the browser will reserve space if it knows the dimensions and aspect-ratio of the image.
* Ensure that ads, iframes and other embeds have a `width` and `height` attribute.
* As a best practice, do not insert dynamic content into the site without the user performing an action to receive it, ie "load more" or "click".
* Ensure that you have a Web Font Loading strategy in place that mitigates layout shift when fonts are loaded and displayed in the browser.
* When animating CSS properties, ensure that you animate `transform` properties rather than `box-model` properties to prevent reflow and layout changes in the browsers [Critical Rendering Path](https://developers.google.com/web/fundamentals/performance/critical-rendering-path)

##### _Handling Ad Sizes_
When it comes to ads, its important that slot sizes are consistent in order to prevent CLS. Ads are generally difficult to predict considering that Ad Servers can serve ads at different heights and widths depending on impression data. There are a number of ways to mitigate this:

1. Speak to Audience and Revenue or your Ad Ops team and see if its possible to ensure that ad units are served at more consistent sizes based on impression analytics.
2. If you can achieve more consistent ad sizes, you can reserve space for ad slots by using the `min-height` CSS property: `<div id="ad-slot" style="min-height: 250px;"></div>`
3. If you want to dynamically set the height and width of ads once the `GPT.js` script has ad data you can use the following function:

```
googletag.pubads().addEventListener('slotRenderEnded', function(event) {
	var size = event.size;
	if(size === null) return;
	var slot = event.slot;
	var slotDiv = document.getElementById(slot.getSlotElementId());

	if (size[0] > slotDiv.clientWidth) {
		slotDiv.style.width = size[0] + 'px';
	}

	if (size[1] > slotDiv.clientHeight) {
		slotDiv.style.height = size[1] + 'px';
	}
});
```

4. A combination of both 2 and 3 has yielded great improvement to CLS scores.
5. Consider using `googletag.pubads().collapseEmptyDivs();` to ensure that ad slots that probably wont fill take up no height and width on the page.

##### _Handling Web Fonts_
Handling FOUT (Flash of Unstyled Text) and FOIT (Flash of Invisible Text) have become a much discussed topic recently. Its important to be aware that your page could subscribe to either of the unwanted side-effects of embedding custom fonts. Here's what you an do to mitigate those effects:

1. Use `font-display: swap` if your fonts are hosted locally.
2. Where possible, preload font files using the `<link rel="preload"/>` schema in conjuction with `font-display: optional`
3. Where possible, hosts your fonts locally.
4. Subset your font files if you know that your site will not be translated into other languages.
5. Cache font files on the web server.
6. Use libraries like [WebFontLoader](https://github.com/typekit/webfontloader) to asynchronously load fonts on the page.
7. The [Font Loading API](https://developer.mozilla.org/en-US/docs/Web/API/CSS_Font_Loading_API) can be used as an alternative to WebFontLoader if you're looking for an approach with more control.
8. Ensure that your fallback fonts closely resemble the desired primary font in the stack. A layout shift will / can occur when fallback fonts have different line-heights, kerning and leading.


### First Input Delay

First Input Delay measures the interactivity of web page. It quantifies the users experience with regards to how fast the page load feels.
By maintaining a low FID score, users will *feel* like the page is loading faster.

First Input Delay is specifically purposed for measuring how quickly the page becomes interactive to the user on their first impression, where as a vital such as First Contentful Paint measures how quickly the page becomes visible. These are 2 important concepts to grasp when it comes to debugging and diagnosing Core Web Vitals.

> An FID score of 100 milliseconds (ms) or less is considering to be a conducive measurement for good user experience.

FID is a unique Core Web Vital and is not actually tracked in Lighthouse or other service metrics. FID is a field metric, meaning that its score is generated by collating data from millions of websites accessed by Google Chrome users. When it come to generating a score for FID "in the lab" or otherwise through Lighthouse, you will be looking to improve the [Total Blocking Time (TBT)](https://web.dev/tbt/) metric. You can think of TBT as a proxy to FID. This is because FID requires a real user and real users cannot be "spoofed" by Lighthouse.

Most importantly, this vital measures the delay from when an event has been received to when the main thread of the browser is idle, this is also known as "input latency". The "event" can include user events like clicks or taps, but there are far more events in JavaScript that do not require actual user input. FID does not measure the time it take to actually process the event in JavaScript or the time that it takes to update the UI based on event handlers.

#### How to diagnose First Input Delay

Unfortunately, diagnosing Total Blocking Time in Chrome is not as easy as diagnosing Largest Contentful Paint or Cumulative Layout Shift.
One of the biggest clues for diagnosing TBT is identifying heavy JavaScript execution on the main thread. This requires an understanding of how the browser parses HTML and JavaScript as well as what is known as a [Long Task](https://web.dev/custom-metrics/#long-tasks-api). A Long Task is any JavaScript-based task on the main thread that takes longer than 50 milliseconds (ms) to execute. While the browser is executing a JS task on the main thread, it cannot respond to any user input, as JavaScript is not a multi-threaded language.

You can identify any Long Tasks on your webpage by following these steps:

1. Open _Google Chrome_
2. Open _Chrome DevTools_
3. Select the _Performance_ Tab
4. Check the _Web Vitals_ checkbox
5. Click the _Reload_ button or hit `⌘ ⇧ E` shortcut
6. Scroll down to _Main_
7. If there are Long Task's recorded during page load, you'll see a grey bar labelled by "Task" and then a red diagonal pattern overlay.
8. Hovering or clicking on this bar will indicate a long task in the browsers main thread.
9. In order to better understand and pin-point the offending execution, you can click on "Call Tree".
10. Once in the "Call Tree" dialog you will see under "Activity" that the length of the task is broken down into function calls and will provide you with a link to the offended JavaScript source file. You can continue your debugging from there.

Using Google Chromes "Coverage" tab can provide critical insight into how much of the JavaScript on the page is actually being used.
Identifying this code can help you off-load non-critical JavaScript until after page load.

#### How to fix First Input Delay
FID can be fixed in a number of ways that relate to analyzing JavaScript performance:

* Breaking up Long Tasks
* Optimizing your web page for interaction readiness
* Using a web worker
* Reducing JavaScript execution time.

We've already discussed at a high-level what Long Tasks are, but more importantly, we want to make sure that these long tasks can be broken up into smaller, asynchronous tasks. This can be achieved by code-splitting your JavaScript bundles using [ES6 Dynamic Import](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import#dynamic_imports) syntax as well as keeping an eye on polyfill's clogging up your main bundle. Fallback polyfills can add a tremendous amount of bloat to bundle sizes.

Other factors to look at are the size of your JavaScript bundles as well as how many JavaScript files your page is loading during initial load. If the main thread has to parse unnecessary JavaScript that may not be needed by the user the chance of Long Tasks preventing user interaction during load rises exponentially. Where possible you should also defer the fetching of data from API services as network latency can also effect TBT.

One area of conversation (especially with clients) should be around the number and purpose of 3rd-party scripts. Multiple 3rd-party scripts can quickly become unmaintainable and lead to delayed JavaScript execution. Ensuring 3rd party scripts use the `async` and `defer` attributes can also help improve latency.

### Measuring
A plethora of tools have become available to manage and maintain healthy Core Web Vitals. In fact, most performance/reporting based tools now offer some kind of Web Vitals-based data. At 10up, we use the following tools to report accurate Web Vital metrics:

#### _[Web Vitals NPM Package](https://www.npmjs.com/package/web-vitals)_
This library can be used during development to diagnose Web Vital metrics. It comes with a fairly easy to understand API that directly tracks
Web Vital data on page load. The data can be a bit hard to read but if you're looking for a programmatic approach to understanding the health
of you web page, this library wont let you down.

```
import {getLCP, getFID, getCLS} from 'web-vitals';

getCLS(console.log);
getFID(console.log);
getLCP(console.log);

```

You can also use this library if you would like to send site data on Web Vitals directly to your analytics service. The package wont help you
identify whats wrong, but it will tell you where your site is starting to slip in terms of web vitals health in a customized and dynamic way.

```
import {getCLS, getFID, getLCP} from 'web-vitals';

function sendToAnalytics(metric) {
  const body = JSON.stringify({[metric.name]: metric.value});
  // Use `navigator.sendBeacon()` if available, falling back to `fetch()`.
  (navigator.sendBeacon && navigator.sendBeacon('/analytics', body)) ||
      fetch('/analytics', {body, method: 'POST', keepalive: true});
}

getCLS(sendToAnalytics);
getFID(sendToAnalytics);
getLCP(sendToAnalytics);

```

#### _[Lighthouse/Lighthouse CLI](https://github.com/GoogleChrome/lighthouse)_
Lighthouse which is built into Google Chrome's DevTools is a significant tool for tracking performance data on an ad-hoc basis.
Whereas the tool is accurate and performs many important audits, it should only be used as a "check up" on performance data and not a real assumption of how multiple users perceive performance on the site.

The Lighthouse CLI tool can also be used with more efficiency if you are managing multiple URL sets. To install the CLI:

```
npm install -g lighthouse
```
then run the CLI against a URL:

```
lighthouse <url> --preset=desktop --view
```

#### _[WebPageTest](https://www.webpagetest.org/)_

WebPageTest is the preferred tool at 10up for compiling performance budgets and identifying areas of improvement.
We run tests with the following settings:

* Test Location: *Virginia - EC2(Chrome, Firefox)*
* Browser: *Chrome*
* Connection: *3G Fast (1.6 Mbps/768 Kbps 150ms RTT)*
* Desktop Browser Dimensions: *default (1366x768)*
* Number of Tests to Run: *9*
* Repeat View: *First View Only*

These settings give us median test range to see accurate results. An incredibly useful feature of WebPageTest is their _Chrome Field Performance_ section which reports on where your site lands up based on the 75th percentile of all websites that Chrome tracks in the [Chrome UX Report (CrUX)](https://developers.google.com/web/tools/chrome-user-experience-report). This is a really important contextful feature that should not be ignored.

#### _[Web Vitals Chrome Extention](https://chrome.google.com/webstore/detail/web-vitals/ahfhijdlegdabablpippeagghigmibma?hl=en)_
Addy Osmani has written a really useful and compact extention that reports on the 3 Core Web Vitals.

### Further reading {% include Util/top %}

* [Optimize Largest Contentful Paint](https://web.dev/optimize-lcp)
* [Optimize Cumulative Layout Shift](https://web.dev/optimize-cls/)
* [Optimize First Input Delay](https://web.dev/optimize-fid/)
* [The business impact of Core Web Vitals](https://web.dev/vitals-business-impact/)
* [Getting started with measuring Web Vitals](https://web.dev/vitals-measurement-getting-started/)
* [Preloading responsive images](https://web.dev/preload-responsive-images/)




