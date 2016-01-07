### Performance

Writing performant code is absolutely critical. Poorly written JavaScript can significantly slow down and even crash the browser. On mobile devices, it can prematurely drain batteries and contribute to data overages. Performance at the browser level is a major part of user experience which is part of the 10up mission statement.

#### Only Load Libraries You Need

JavaScript libraries should only be loaded on the page when needed. jquery-1.11.1.min.js is 96 KB. This isn't a huge deal on desktop but can add up quickly on mobile when we start adding a bunch of libraries. Loading a large number of libraries also increases the chance of conflictions.

#### Use jQuery Wisely

[jQuery](http://jquery.com/) is a JavaScript framework that allows us easily accomplish complex tasks such as AJAX and animations. jQuery is great for certain situations but overkill for others. For example, let's say we want to hide an element:

```javascript
document.getElementById( 'element' ).style.display = 'none';
```

vs.

```javascript
jQuery( '#element' ).hide();
```

The non-jQuery version is [much faster](http://jsperf.com/hide-with-and-without-jquery) and is still only one line of code.

#### Try to Pass an HTMLElement or HTMLCollection to jQuery Instead of a Selection String

When we create a new jQuery object by passing it a selection string, jQuery uses its selection engine to select those element(s) in the DOM:

```javascript
jQuery( '#menu' );
```

We can pass our own [HTMLCollection](https://developer.mozilla.org/en-US/docs/Web/API/HTMLCollection) or [HTMLElement](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement) to jQuery to create the same object. Since jQuery does a lot of magic behind the scenes on each selection, [this will be faster](http://jsperf.com/wrap-an-element-or-html-collection-in-jquery):

```javascript
jQuery( document.getElementById( 'menu' ) );
```

#### Cache DOM Selections

It's a common JavaScript mistake to reselect something unnecessarily. For example, every time a menu button is clicked, we do not need to reselect the menu. Rather, we select the menu once and cache its selector. This applies whether you are using jQuery or not. For example:

non-jQuery Uncached:

```javascript
var hideButton = document.getElementsByClassName( 'hide-button' )[0];
hideButton.onclick = function() {
    var menu = document.getElementById( 'menu' );
    menu.style.display = 'none';
}
```

non-jQuery Cached:

```javascript
var menu = document.getElementById( 'menu' );
var hideButton = document.getElementsByClassName( 'hide-button' )[0];
hideButton.onclick = function() {
    menu.style.display = 'none';
}
```

jQuery Uncached:

```javascript
var $hideButton = jQuery( '.hide-button' );
$hideButton.on( 'click', function() {
    var $menu = jQuery( '#menu' );
    $menu.hide();
});
```

jQuery Cached:

```javascript
var $menu = jQuery( '#menu' );
var $hideButton = jQuery( '.hide-button' );
$hideButton.on( 'click', function() {
	$menu.hide();
});
```
Notice how in cached versions we are pulling the menu selection out of the event handler so it only happens once. Non-jQuery cached is not surprisingly the [fastest way to handle this situation](http://jsperf.com/dom-selection-caching).

#### Event Delegation

Event delegation is the act of adding one event listener to a parent node to listen for events bubbling up from children. This is much more performant than adding one event listener for each child element. Here is an example:

Without jQuery:

```javascript
document.getElementById( 'menu' ).addEventListener( 'click', function( event ) {
    if( event.target && event.target.nodeName === 'LI' ) {
        // Do stuff!
    }
});
```

With jQuery:

```javascript
jQuery( '#menu' ).on( 'click', 'li', function() {
    // Do stuff!
});
```

The non-jQuery method is as usual [more performant](http://jsperf.com/jquery-vs-non-jquery-event-delegation). You may be wondering why we don't just add one listener to ```<body>``` for all our events. Well, we want the event to *bubble up the DOM as little as possible* for [performance reasons](http://jsperf.com/event-delegation-distance). This would also be pretty messy code to write.

<h3 id="design-patterns">Design Patterns {% include Util/top %}</h3>

Standardizing the way we structure our JavaScript allows us to collaborate more effectively with one another. Using intelligent design patterns improves maintainability, code readability, and even helps to prevent bugs.

#### Don't Pollute the Window Object

Adding methods or properties to the ```window``` object or the global namespace should be done carefully. ```window``` object pollution can result in collisions with other scripts. We should wrap our scripts in closures and expose methods and properties to ```window``` decisively.

When a script is not wrapped in a closure, the current context or ```this``` is actually ```window```:

```javascript
window.console.log( this === window ); // true
for ( var i = 0; i < 9; i++ ) {
    // Do stuff
}
var result = true;
window.console.log( window.result === result ); // true
window.console.log( window.i === i ); // true
```

When we put our code inside a closure, our variables are private to that closure unless we expose them:

```javascript
( function() {
    for ( var i = 0; i < 9; i++ ) {
        // Do stuff
    }

    window.result = true;
})();

window.console.log( typeof window.result !== 'undefined' ); // true
window.console.log( typeof window.i !== 'undefined' ); // false
```

Notice how ```i``` was not exposed to the ```window``` object.

#### Use Modern Functions, Methods, and Properties

It's important we use language features that are intended to be used. This means not using deprecated functions, methods, or properties. Whether we are using a JavaScript or a library such as jQuery or Underscore, we should not use deprecated features. Using deprecated features can have negative effects on performance, security, maintainability, and compatibility.

For example, in jQuery ```jQuery.live()``` is a deprecated method:

```javascript
jQuery( '.menu' ).live( 'click', function() {
    // Clicked!
});
```

We should use ```jQuery.on()``` instead:

```javascript
jQuery( '.menu' ).on( 'click', function() {
    // Clicked!
});
```

Another example in JavaScript is ```escape()``` and ```unescape()```. These functions were deprecated. Instead we should use ```encodeURI()```, ```encodeURIComponent()```, ```decodeURI()```, and ```decodeURIComponent()```.


<h3 id="code-style">Code Style & Documentation {% include Util/top %}</h3>

We conform to [WordPress JavaScript coding standards](http://make.wordpress.org/core/handbook/coding-standards/javascript/).

We conform to the [WordPress JavaScript Documentation Standards](https://make.wordpress.org/core/handbook/best-practices/inline-documentation-standards/javascript/).

<h3 id="unit-and-integration-testing">Unit and Integration Testing {% include Util/top %}</h3>

At 10up, we generally employ unit and integration tests only when building applications that are meant to be distributed. Writing tests for client themes usually does not offer a huge amount of value (there are of course exceptions to this). When we do write tests, we use [Mocha](http://mochajs.org).

<h3 id="libraries">Libraries {% include Util/top %}</h3>

There are many JavaScript libraries available today. Many of them directly compete with each other. We try to stay consistent with what WordPress uses. The following is a list of primary libraries used by 10up.

#### DOM Manipulation

[jQuery](http://jquery.com/) - Our and WordPress's library of choice for DOM manipulation.

#### Utility

[Underscore](http://underscorejs.org) - Provides a number of useful utility functions such as ```clone()```, ```each()```, and ```extend()```. WordPress core uses this library quite a bit.

#### Frameworks

[Backbone](http://backbonejs.org) - Provides a framework for building complex JavaScript applications. Backbone is based on the usage of models, views, and collections. WordPress core relies heavily on Backbone especially in the media library. Backbone requires Underscore and a DOM manipulation library (jQuery)

