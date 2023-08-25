<h2 id="seo" class="anchor-heading">SEO {% include Util/link_anchor anchor="seo" %} {% include Util/top %}</h2>

Kanopi's SEO goal on a Lighthouse / Page SpeedInsights scan is 92/100. In addition to that, there are methods that are not measured on that tool that can improve SEO. Google currently sets the industry standard for search algorithms and will be referenced often in this document. 

The expectation is that these items will be incorperated into the site as it is developed and not left until pre-launch. 

<h2 id="basics" class="anchor-heading">SEO Basics {% include Util/link_anchor anchor="basics" %} {% include Util/top %}</h2>

### Headings

*   Every page must have an h1
*   There should only be one h1 on the page
*   The h1 should identify the purpose of the page
*   The h1 should match the page title
    *   The main exception to this is the homepage. Typically you would not have an h1 of "Home" (which would be seen in the page title) but rather an h1 that includes the name of the business or company. 
    *   "Power statements" sometimes get used here too, but it would be better to include a statement as a paragraph and provide a relevant h1 for search engines and assistive technology.
*   Headings that are not followed by content are not appropriate as headings 
    *   Headings that are followed by sub headings are okay, provided the sub headings have content. But if you have two h2s in a row, or two h3s, etc, with no content in between, then those are not appropriate headings.
    *   Google **recommends** that there is content after every heading.
*   Use heading tags to structure your content hierarchically (recommended by Google and for Accessibility reasons).
*   Choose headings based on hierarchy rather than style.


Note: You can check your site for duplicate, multiple, and missing `<h1>` tags with a Screaming Frog report.

References:  
[Accessibility Headings](/accessibility#headings)  


---

### Links

*   Don't use the same link text in the same document for different target pages.
    *   This is a big accessibility point as well. Links with the same name that go to different locations are confusing and misleading.
*   When writing complete sentences that have inline liks, ensure the link is unique and dsicriptive, making sense without the surrounding text.
    *   "this document", "this article", "click here", "read more" are useless for assistive technology and search engines.
*   Do not use the full url as the link text unless it is required for legal reasons.
*   Keep link text short and concise.
*   Place important words at the begining of the link text.
*   Indicate if the link downloads the document by including "download" in the link text.
    *   This can easily be done with screen reader text if the design does not call for the word download to appear.


References:  
[Accessibility Links](/accessibility#links)  


---

### Images

*   All image elements require the `alt` attribute. **There are no exceptions.**
*   Images that are decorative (swoops, patterns, design elements) can have an empty alt. 
*   Images that convey meaning, content, or context must have alt text that describes them.
*   Images that are used as links or buttons must have an alt that describes what will happen when the image is clicked.
*   Images of text must include that text in the alt text or in a nearby block of content such as a caption.
*   Icons that accompany a label or heading of some kind are considered decorative.

These are both valid methods of attaching an empty alt attribute:
```
<img src="#" alt="" >
<img src="#" alt >
```


References:  
[Accessibility Images](/accessibility#images)  


<h2 id="meta" class="anchor-heading">Head Data {% include Util/link_anchor anchor="meta" %} {% include Util/top %}</h2>

### Metadata 
At a mimimum, the `<head>` must include metadata properties for:
*   Title  
`<title>Title of Page / Website</title>`
*   Description  
`<meta name="description" content="A concise but complete description of the page / site purpose." />`
*   Viewport   
`<meta name="viewport" content="width=device-width, initial-scale=1">`
*   Canonical  
`<link rel="canonical" href="https://domain.com" />`

---

### Schema
Schema is typically applied on a page per page basis and can range from basic schema to complex.

For WordPress, schema can be applied via the [Yoast](https://wordpress.org/plugins/wordpress-seo/) plugin. See [Yoast section](#yoast) for more information.
For WordPress, schema can be applied via the [Rank Math](https://wordpress.org/plugins/seo-by-rank-math/) plugin. See [Rank Math section](#rankmath) for more information.

For Drupal, schema is applied via the [Schema.org Metatag](https://www.drupal.org/project/schema_metatag) module. See [Metatag section](#metatag) for more information.

Advanced schema typically requires custom work with programatic data fields and will not be covered here.

---

### Language
Each page requires `<html lang="en-US">` to ensure the language of the page is identified for accessibility purposes.

If a page is targeted to a specific region, then a hreflang is also recommended.  
```
<link rel="alternate" hreflang="en" href="https://domain.com" />
<link rel="alternate" hreflang="es" href="https://es.domain.com" />
<link rel="alternate" hreflang="de" href="https://de.domain.com" />
```
Sites that use language selection to deliver different content should always have these hreflangs. This helps search engines identify regionally appropriate content and provide the user with the associated url.


<h2 id="searchability" class="anchor-heading">Searchability {% include Util/link_anchor anchor="searchability" %} {% include Util/top %}</h2>

### Redirects
Rethemes, rebuilds, or sites with migrated content will often have urls that do not line up with the previous version of the site. Those urls will still be indexed and searchable by search engines but will result in 404s. To prevent this and preserve SEO equity, ensure there are redirects in place to send the user to the most appropriate url based on the old url.

For WordPress, the [Redirection plugin](https://wordpress.org/plugins/redirection/) is sufficient.

For Drupal, the [Redirect module](https://www.drupal.org/project/redirect) is sufficient.


---

### Robots

Robots must be able to crawl the site once it's live.

In WordPress, there is a default robots.txt file. Yoast / Rank Math will make edits to this file based on its settings, and it will add a site index there as well. When going to production, there is a setting in the WordPress admin to allow the site to be discoverable by search engines; it is essential that this is toggled.

**Drupal instructions coming soon.**



<h2 id="design" class="anchor-heading">Design {% include Util/link_anchor anchor="design" %} {% include Util/top %}</h2>

Font sizes must be larger than 12px. Anything smaller than that will result in a score reduction.

Tap sizes should be 44px by 44px. Generally navigation lists and inline links are an exception to this rule, but icons used as buttons or links require a 44px by 44px activation area, even if the icon is smaller than that. This is also an accessibility requirement.

References:  
[Accessibility Links](/accessibility#links)  


<h2 id="other" class="anchor-heading">Other Factors {% include Util/link_anchor anchor="other" %} {% include Util/top %}</h2>

### Performance

The Lighthouse / Page Speed Insights scan also includes performance issues. Performance score will impact the overall score in Google's algorithm. The goal is to be 55% or better on a mobile scan. Be aware that Page Speed Insights will often score performance higher than Lighthouse, but Lighthouse should be considered more accurate. It is also the metric used in Kanopi's own tracking.

Address as many non-third-party performance issues as you can. This will save time at pre-launch and promote better development habits.

---

### Accessibility

This metric also impacts the overall site ranking. Lighthouse only scans for 44 possible errors and has a limited capacity to scope the accessibility of a website. There is no reason your site should not have 100/100.

Please review the [Accessibility](/accessibility) practices for more information.  

<h2 id="yoast" class="anchor-heading">Yoast (WordPress) {% include Util/link_anchor anchor="yoast" %} {% include Util/top %}</h2>

At the moment, Yoast is one of the go-to plugins for WordPress Sites. At some point on your project you should be configuring Yoast.

### General > First Time Configuration

*   Go through this Wizard. 
*   Fill in everything you can and ask the project manager for any information you may be missing.

### Settings > General

*   Depending the the client, you may or may not wish to turn off some of the analysis metrics from Yoast. They can be alarming for people who are not familiar with SEO, or the limitations of yoast.
*   All Social Sharing features should be enabled. All APIs should be enabled.
*   Open the XML Sitemap for reference. You will need this later.
*   Pipebars are the most attractive title separator. Just saying.
*   Some fields in the General section may or may not be populated from the First Time Configuration. Fill in anything that did not get populated.
*   Add all social profiles. You can usually find this on the previous version of the site, or get it from the project manager.
*   Under site connections, give the provided google search console link to the project manager and ask them to have the client obtain the verification code.

### Settings > Content Types

*   For the homepage, open it in a new window and edit its individual Yoast settings. 
    *   The title should be "Site Title" "Separator" "Site Description" - this is the only page that gets a unique title structure.
    *   Craft a meta description for the overall site. If this is out of your wheelhouse, ask a project manager for the text to be provided.
*   Posts, Pages and Custom Post Types
    *   Determine which post types should be shown in search results. If a post type does not have proper single template, please ensure it is set not to show and check with the project manager if the post type should have a single.
    *   Each findable post type needs an SEO title filled out "Title" "Separator" "Site Title"
    *   Each findable post type needs at a minimum the "Excerpt" variable. For some post types it might be valuable to write something custom. For example, on resource CPT, you may want to include the category of resource, or another taxononmy. "View the TITLE webinar posted on PUBLISH DATE. EXCERPT". Use your best judgement. 
    *   Each findable post type needs the Schema filled out. For the most type Web Page > Article are appropriate settings, but check to see if something there fits better.
    *   Ignore premium fields unless the client has a premium subscription.
*   Categories & Tags
    *   These operate similarly to the post types. Each can be shown in the search results, or hidden. Check each taxonomy's term  pages to see if they are templated. If not, hide them and check with the project manager that this is correct.
    *   Each findable taxonomy needs an SEO title filled out "Term Title" "Separator" "Site Title"
    *   Each findable post type needs at a minimum the "Excerpt" variable. Terms may not have a description or excerpt depending on the site features. In this case it might be more appropriate to customize to "View all posts related to TERM TITLE" or something similar.
*   Crawl Optimization
    *   Check for anything that should be disabled. If you're unsure, check with the tech lead of your project or ask for help in Slack.
*   Breadcrumbs
    *   If breadcrumbs are in use, configure these here.
*   Author Archives
    *   99% of the time these should be disabled. If they are relevant for your site, be sure to fill in the Search appearance appropriately.
*   Date Archives
    *   99% of the time these should be disabled. If they are relevant for your site, be sure to fill in the Search appearance appropriately.
*   Format Archives
    *   99% of the time these should be disabled. If they are relevant for your site, be sure to fill in the Search appearance appropriately.
*   Special Pages
    *   Here you can set the search title and 404 title. The default is probably sufficient but it is good to check.
*   Media Pages
    *   Typically these should be disabled unless there is a reason the client would like attachment urls to be available.
    *   If attachment urls are made available, those may require some styling. Check a sample attachment url and confirm with the project manager.
    *   If attachment urls are made available, be sure to fill in the Search appearance and Schema appropriately. 
*   RSS
    *   Depending on the purpose of the site, an RSS feed may be appropriate. Check with your tech lead if you are uncertain.

Once you're done this, pull up that XML sitemap and refresh. Go through each path, sampling each post type and taxonomy as you go so that you can confirm there are no broken experiences.

### Remaining Menu Items 

The rest of Yoast is generally left unused but if you have need of premium features or importing/exporting you can find those sections in the remaining menu items below "Settings".


<h2 id="rankmath" class="anchor-heading">Rank Math (WordPress) {% include Util/link_anchor anchor="rankmath" %} {% include Util/top %}</h2>

At the moment, Rank Math is a new plugin we are trying for WordPress Sites. At some point on your project you should be configuring Rank Math. Note that Rank Math is also a substitute for the Redirection plugin and otherwise has all the same features as Yoast.

### Setup

Initially the plugin will ask you to connect an account and complete a wizard. You can skip these steps and go straight to the dashboard. Move through "General Settings", "Titles & Metta", and "Sitemap Settings". Additional items can be completed if relevant.

Ensure all posts, pages, custom post types, and taxonomies are appropriately titled, with descriptions and schema. Ensure items that do not have archives or single templates are not indexed. Rank Math is very similar to Yoast, so see that section for more details if needed.

### Importing

If you import from Yoast, review all of the same items identified in setup as some of the import will need editing to work. Double check everything, with Yoast disabled. Rank Math and Yoast should not be used at the same time.


<h2 id="metatag" class="anchor-heading">Metatag (Drupal) {% include Util/link_anchor anchor="metatag" %} {% include Util/top %}</h2>

If you need to include Schema, there is an add-on for this module that supplies those features.

### Global

*   Must fill:
    *   Page Title `[current-page:title | site:name]`
    *   Description `[current-page:metatag:description]`
    *   Canonical URL `[current-page:url]`
*   Other
    *   Fill if appropriate
    *   Consider adding images to og_image and image_src as fallbacks
*   Facebook / Twitter
    *   Fill if appropriate
*   Site Verification
    *   Ask project manager to get the Google Site Verification from the client. Include client friendly instructions.

### Front Page
*   Include a custom description
*   Include a custom home page title (often something that starts with the company and ends with a concise summary of its purpose)

### Content
*   Set any overrides, for example nodes for descriptions, images, title, etc.

### Content Additional Types
*   Inherit from Global & Content
*   Set any overrides, for example nodes for descriptions, images, title, etc.

### Taxonomy Terms
*   Set url, description, and title according to the term instead of current page

### User
*   Set url, description, and title according to the user instead of current page 

Test all views to ensure there is a page title, accurate cannonical url, and meta description on every one. If a view is missing any of the three, ensure that the page is non indexable, or that those items get added appropriately. These three items will significantly impact the page's SEO score with Google.
