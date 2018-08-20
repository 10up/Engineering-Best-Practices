<h2 id="performance" class="anchor-heading">Performance</h2>

Writing performant code is absolutely critical. Poorly written JavaScript can significantly slow down and even crash the browser. On mobile devices, it can prematurely drain batteries and contribute to data overages. Performance at the browser level is a major part of user experience which is part of the 10up mission statement.

We have a published [.eslint](https://www.npmjs.com/package/@10up/eslint-config) configuration that's used on 10up projects. This linting is included in our [theme scaffolding](https://github.com/10up/theme-scaffold) and [plugin scaffolding](https://github.com/10up/plugin-scaffold) and should help you adhere to our coding standards.

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

On all new projects you should be using up to date JavaScript methodologies combined with a build process tool like [Babel](https://babeljs.io/) to ensure browser compatibility. This allows us to utilize modern techniques while being certain our code will not break in older systems. The [theme scaffolding](https://github.com/10up/theme-scaffold) and [plugin scaffolding](https://github.com/10up/plugin-scaffold) have this functionality built in.

Some older projects that have not yet been upgraded may not have the capability to use the most modern techniques, but it is still important to have processes in place that allow us to grow the technology stack as a project matures. In these cases, you should still follow best practice recommendations even if the newest patterns are not yet available to you.


<h2 id="code-style" class="anchor-heading">Code Style & Documentation {% include Util/top %}</h2>

We conform to the [WordPress JavaScript coding standards](http://make.wordpress.org/core/handbook/coding-standards/javascript/).

We conform to the [WordPress JavaScript documentation standards](https://make.wordpress.org/core/handbook/best-practices/inline-documentation-standards/javascript/).

<h2 id="unit-and-integration-testing" class="anchor-heading">Unit and Integration Testing {% include Util/top %}</h2>

At 10up, we generally employ unit and integration tests only when building applications that are meant to be distributed. Writing tests for client themes usually does not offer a huge amount of value (there are of course exceptions to this). When writing tests, it's important to use the framework that best fits the situation and make sure it is well documented for future engineers coming onto the project.

<h2 id="libraries" class="anchor-heading">Libraries {% include Util/top %}</h2>

There are many JavaScript libraries available today. Many of them directly compete with each other. We try to stay consistent with what WordPress uses. The following is a list of primary libraries used by 10up.

### Components
[WP Component Library](https://10up.github.io/wp-component-library/) - Provides us with a vetted, accessible, and standardized collection of UI component and Schema snippets we can use on projects.

### Utility

[Underscore](http://underscorejs.org) - Provides a number of useful utility functions such as ```clone()```, ```each()```, and ```extend()```. WordPress core uses this library quite a bit.

### Frameworks

[React](https://reactjs.org/) - Using React provides a library to create large-scale, stateful JavaScript applications. It aims to provide a flexible system of creating highly componentized user interfaces. [Learn more about how we use React]({{ site.baseurl }}/react).

[Vue](https://vuejs.org/) - Implementing Vue on a project allows us to take advantage of the statefulness built into something like React, but apply it on a much more lightweight and smaller scale as to not bog down performance by loading in a heavy library. [Learn more about how we use Vue]({{ site.baseurl }}/vue).

[Backbone](http://backbonejs.org) - Provides a framework for building complex JavaScript applications. Backbone is based on the usage of models, views, and collections. WordPress core relies heavily on Backbone especially in the media library. Backbone requires Underscore and a DOM manipulation library.
