<h2 id="performance" class="anchor-heading">Performance</h2>

Writing performant code is absolutely critical. Poorly written JavaScript can significantly slow down and even crash the browser. On mobile devices, it can prematurely drain batteries and contribute to data overages. Performance at the browser level is a major part of user experience which is part of the WisdmLabs mission statement.

We have a published [.eslint](https://www.npmjs.com/package/@WisdmLabs/eslint-config) configuration that's used on WisdmLabs projects. This linting is included in our [theme scaffolding](https://github.com/WisdmLabs/theme-scaffold) and [plugin scaffolding](https://github.com/WisdmLabs/plugin-scaffold) and should help you adhere to our coding standards.

### Only Load Libraries You Need

JavaScript libraries should only be loaded on the page when needed. React + React DOM are around 650 KB together. This isn't a huge deal on a fast connection but can add up quickly in a constrained bandwidth situation when we start adding a bunch of libraries. Loading a large number of libraries also increases the chance of conflicts.

### Use Libraries and Frameworks Wisely

With the influx of JavaScript upgrades in recent years, the need for a third-party library to polyfill functionality is becoming more and more rare (outside of a build script). Don't load in extensions unless the benefit outweighs the size of and added load-time of using it. While it is often more efficient for coding to use a quick jQuery method, it is rarely worth bringing in an entire library for one-off instances. [Read our section on Libraries and Frameworks for more specific information](#libraries).

If you are working on a legacy project that already contains a library, make sure you're still evaluating the need for it as you build out features to best set up clients for the future.

### Cache DOM Selections

It's a common JavaScript mistake to reselect something unnecessarily. For example, every time a menu button is clicked, we do not need to reselect the menu. Rather, we select the menu once and cache its selector. This applies whether you are using a library or not. For example:

Uncached:

```javascript
const hideButton = document.querySelector( '.hide-button' );

hideButton.addEventListener( 'click', () => {
    const menu = document.getElementById( 'menu' );
    menu.style.display = 'none';
} );
```

Cached:

```javascript
const menu = document.getElementById( 'menu' );
const hideButton = document.querySelector( '.hide-button' );

hideButton.addEventListener( 'click', () => {
    menu.style.display = 'none';
}
```

Notice how, in cached versions, we are pulling the menu selection out of the event listener so it only happens once. The cached version is, not surprisingly, the [fastest way to handle this situation](https://jsperf.com/dom-selection-caching).

#### Event Delegation

Event delegation is the act of adding one event listener to a parent node to listen for events bubbling up from its children. This is much more performant than adding one event listener for each child element. Here is an example:

```javascript
document.getElementById( 'menu' ).addEventListener( 'click', ( e ) => {

    const currentTarget = e.currentTarget;
    let target = event.target;

    if ( currentTarget && target ) {
      if ( 'LI' === target.nodeName ) {
        // Do stuff with target!
      } else {
        while ( currentTarget.contains( target ) ) {
          // Do stuff with a parent.
          target = target.parentNode;
        }
      }
    }

} );
```
You may be wondering why we don't just add one listener to the ```<body>``` for all our events. Well, we want the event to *bubble up the DOM as little as possible* for [performance reasons](https://jsperf.com/event-delegation-distance). This would also be pretty messy code to write.

<h2 id="client-side-data" class="anchor-heading">Client-side Data {% include Util/top %}</h2>

When dealing with client-side data requests (Ajax calls), there are a lot of different methods to consider. This portion of the document will walk you through various situations and talk about the different technologies and patterns you may encounter along the way.

### Using Fetch and Promises for Modern Environments
The Fetch API is a modern replacement for the XMLHttpRequest. It is [generally well supported](https://caniuse.com/#search=fetch), having features present in all evergreen browsers (browsers that auto-update). Fetch is recommended to be used in all modern environments when making Ajax calls or dealing with client-side data requests. Visit the [MDN Fetch documentation](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API) for a basic example of how to use this API.

To properly use fetch, support for Promises also needs to be present (Promises and Fetch have the same [browser support](https://caniuse.com/#search=promise)). The support requirement for both is an important distinction when your project needs to support non-evergreen browsers (IE 11 and under), because both APIs will need to be polyfilled to get Fetch working.

To polyfill with NPM, we recommend adding the following packages to your dependencies: [promise-polyfill](https://www.npmjs.com/package/promise-polyfill) and [whatwg-fetch](https://www.npmjs.com/package/whatwg-fetch). They are both applicable at different points in the build process. Promises are polyfilled at the file-level with an import and fetch is polyfilled at the build level in your task runner. Please see the [official whatwg-fetch documentation](https://www.npmjs.com/package/whatwg-fetch) for detailed installation instructions.

If you are unable to process the polyfills in a modern workflow, the files can also be downloaded and enqueued separately ([fetch](https://cdnjs.com/libraries/fetch), [promise](https://cdn.jsdelivr.net/npm/promise-polyfill@8/)), but if possible, they should be implemented at the build level.

### Using A Normal Ajax Call for Older Environments
For various reasons on a project, you may not be able to use a modern technique for dealing with client-side data requests. If you find yourself in that situation, it usually isn’t necessary to load an entire library like jQuery for a single feature. If you find yourself in this situation try writing a vanilla ajax call instead. Basic ajax calls do not require any pollyfills or fallbacks, with the exception of providing support on very old browsers like, Internet Explorer 6. You can reference the [XMLHttpRequest Browser Compatibility table](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest#Browser_compatibility) on MDN for specific feature support.

Please see the [MDN XMLHttpRequest documentation](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest) for an example of a basic Ajax call.

### When to Use a Client-side Data Request Library
Sometimes a project may require a more robust solution for managing your requests, especially if you will be making many requests to various endpoints. While Fetch can do most (and someday all) of the things we need, there may be a few areas where it could fall short in your project. The a few main items where Fetch may fall short:

- Cancelable requests
- Timeout requests
- Request progress

It should be noted that these are in [active development](https://github.com/github/fetch#aborting-requests) and timeout requests can also be handled by using a [wrapper function](https://davidwalsh.name/fetch-timeout).

Certain libraries have these built in already and are still promised-based, but can also come with a few other advantages that Fetch doesn’t have like: [transformers](https://github.com/axios/axios), [interceptors](https://github.com/axios/axios), and built-in [XSRF protection](https://en.wikipedia.org/wiki/Cross-site_request_forgery). If you find yourself needing these features that are outside the scope of native JavaScript you may want to evaluate the benefit of using a library.

If you plan on making many requests over the lifetime of the application and you don’t need the features listed above, you should consider making a [helper function or module](https://medium.com/@shahata/why-i-wont-be-using-fetch-api-in-my-apps-6900e6c6fe78) that will handle all of your application’s Fetch calls so you can easily include things like: expected error handling, a common URL base, any cookies you may need, any mode changes like CORS, etc.. Overall, you should be able to accomplish what you need to with Fetch in the majority of cases.

Certain codebases may already have such libraries in place. Many legacy projects use [jQuery.ajax()](http://api.jquery.com/jquery.ajax/) to make their requests. If possible, attempt to phase out jQuery for a vanilla solution where appropriate. In many cases, replacing with Fetch or XMLHttpRequest will be possible.

### Concatenating Requests
When constructing a page that contains a lot of client-side data requests you will want to consider concatenating your requests into a single Ajax call. This will help you avoid piling up requests or sending them through callbacks and nested promises when parts of the data depend on other parts.

[GraphQL](https://graphql.org/) is an open source query language that can help with this situation by allowing you to combine multiple API requests into a single call. In a WordPress environment, the [WPGraphQL](https://github.com/wp-graphql/wp-graphql) plugin will let you directly access the WordPress JSON API.

<h2 id="design-patterns" class="anchor-heading">Design Patterns {% include Util/top %}</h2>

Standardizing the way we structure our JavaScript allows us to collaborate more effectively with one another. Using intelligent design patterns improves maintainability, code readability, and even helps to prevent bugs.

### Don't Pollute the Window Object

Adding methods or properties to the ```window``` object or the global namespace should be done carefully. ```window``` object pollution can result in collisions with other scripts. We should wrap our scripts in closures and expose methods and properties to ```window``` with caution.

When a script is not wrapped in a closure, the current context or ```this``` is actually ```window```:

```javascript
console.log( this === window ); // true

for ( var i = 0; i < 9; i++ ) {
    // Do stuff
}

const result = true;

console.log( window.result === result ); // true
console.log( window.i === i ); // true
```

When we put our code inside a closure, our variables are private to that closure unless we expose them:

```javascript
( function() {

    for ( var i = 0; i < 9; i++ ) {
        // Do stuff
    }

    window.result = true;

} )();

console.log( typeof window.result !== 'undefined' ); // true
console.log( typeof window.i !== 'undefined' ); // false
```

Notice how ```i``` was not exposed to the ```window``` object.

### Use Modern Functions, Methods, and Properties

It's important we use language features that are intended to be used. This means not using deprecated functions, methods, or properties. Whether we are using plain JavaScript or a library, we should not use deprecated features. Using deprecated features can have negative effects on performance, security, maintainability, and compatibility.

On all new projects you should be using up to date JavaScript methodologies combined with a build process tool like [Babel](https://babeljs.io/) to ensure browser compatibility. This allows us to utilize modern techniques while being certain our code will not break in older systems. The [theme scaffolding](https://github.com/WisdmLabs/theme-scaffold) and [plugin scaffolding](https://github.com/WisdmLabs/plugin-scaffold) have this functionality built in.

Some older projects that have not yet been upgraded may not have the capability to use the most modern techniques, but it is still important to have processes in place that allow us to grow the technology stack as a project matures. In these cases, you should still follow best practice recommendations even if the newest patterns are not yet available to you.


<h2 id="code-style" class="anchor-heading">Code Style & Documentation {% include Util/top %}</h2>

We conform to the [WordPress JavaScript coding standards](http://make.wordpress.org/core/handbook/coding-standards/javascript/).

We conform to the [WordPress JavaScript documentation standards](https://make.wordpress.org/core/handbook/best-practices/inline-documentation-standards/javascript/).

<h2 id="unit-and-integration-testing" class="anchor-heading">Unit and Integration Testing {% include Util/top %}</h2>

At WisdmLabs, we generally employ unit and integration tests only when building applications that are meant to be distributed. Writing tests for client themes usually does not offer a huge amount of value (there are of course exceptions to this). When writing tests, it's important to use the framework that best fits the situation and make sure it is well documented for future engineers coming onto the project.

<h2 id="libraries" class="anchor-heading">Libraries {% include Util/top %}</h2>

There are many JavaScript libraries available today. Many of them directly compete with each other. We try to stay consistent with what WordPress uses. The following is a list of primary libraries used by WisdmLabs.

### Components
[WP Component Library](https://WisdmLabs.github.io/wp-component-library/) - Provides us with a vetted, accessible, and standardized collection of UI component and Schema snippets we can use on projects.

### Utility

[Underscore](http://underscorejs.org) - Provides a number of useful utility functions such as ```clone()```, ```each()```, and ```extend()```. WordPress core uses this library quite a bit.

### Frameworks

[React](https://reactjs.org/) - Using React provides a library to create large-scale, stateful JavaScript applications. It aims to provide a flexible system of creating highly componentized user interfaces. [Learn more about how we use React]({{ site.baseurl }}/react).

[Backbone](http://backbonejs.org) - Provides a framework for building complex JavaScript applications. Backbone is based on the usage of models, views, and collections. WordPress core relies heavily on Backbone especially in the media library. Backbone requires Underscore and a DOM manipulation library.
