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
    var currentTarget = event.currentTarget;
    var target = event.target;

    if ( currentTarget && target ) {
        while ( currentTarget.contains( target ) ) {
            if ( target.nodeName === 'LI' ) {
                // Do stuff with target!
            } else {
                target = target.parentNode;
            }
        }
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

<h3 id="js-linting">Linting {% include Util/top %}</h3>
At 10up, we use [ESLint](http://eslint.org/) to detect errors and potential problems in our code. ESLint is a pluggabled linting utility for JavaScript that allows us to automate error detection and conformity to the WordPress JavaScript coding standards. We use [grunt-eslint](https://github.com/sindresorhus/grunt-eslint) to integrate ESLint into a project's Grunt configuration, which tests the project's JavaScript files. ESLint's configuration specifications can be included in a [configuration file](http://eslint.org/docs/user-guide/configuring#configuration-file-formats) which is specified as an option in [ESLint options in Grunt](https://github.com/sindresorhus/grunt-eslint#custom-config-and-rules). Additional details on integrating ESLint into Grunt can be found on the [grunt-eslint GitHub page](https://github.com/sindresorhus/grunt-eslint#usage).

Example ESLint configuration that conforms to the WordPress JavaScript coding standards:

```javascript
{
	"env": {
		"browser": true,
		"jquery": true,
		"node": true
	},
	"globals": {
		"require": true,
		"describe": true,
		"description": true,
		"module": true,
		"chai": true,
		"it": true
	},
	"rules": {
		"accessor-pairs": [2],
		"block-scoped-var": [2],
		"brace-style": [2],
		"callback-return": [2, ["callback", "cb", "next"]],
		"camelcase": [2],
		"comma-dangle": [2],
		"comma-spacing": [2, {"before": false, "after": true}],
		"comma-style": [2, "last"],
		"complexity": [2, 20],
		"consistent-return": [0],
		"consistent-this": [2, "self"],
		"constructor-super": [2],
		"curly": [2],
		"default-case": [2],
		"dot-notation": [2],
		"dot-location": [2],
		"eqeqeq": [2],
		"eol-last": [2],
		"func-style": [2, "expression"],
		"global-require": [2],
		"guard-for-in": [0],
		"handle-callback-err": [2, "^err(or)?$"],
		"id-length": [0],
		"id-match": [2, ""],
		"indent": [2, "tab", {"SwitchCase": 1}],
		"init-declarations": [0],
		"keyword-spacing": [2],
		"max-depth": [2, 6],
		"max-len": [2, 100, 4],
		"max-nested-callbacks": [0],
		"max-params": [2, 3],
		"max-statements": [0],
		"new-cap": [0],
		"new-parens": [2],
		"newline-after-var": [2],
		"no-alert": [2],
		"no-array-constructor": [2],
		"no-bitwise": [0],
		"no-caller": [2],
		"no-case-declarations": [2],
		"no-catch-shadow": [2],
		"no-class-assign": [2],
		"no-cond-assign": [2],
		"no-console": [2],
		"no-const-assign": [2],
		"no-constant-condition": [0],
		"no-continue": [0],
		"no-control-regex": [2],
		"no-debugger": [2],
		"no-delete-var": [2],
		"no-div-regex": [0],
		"no-dupe-args": [2],
		"no-dupe-class-members": [2],
		"no-dupe-keys": [2],
		"no-duplicate-case": [2],
		"no-else-return": [0],
		"no-empty-character-class": [2],
		"no-empty-pattern": [2],
		"no-empty": [2],
		"no-eq-null": [2],
		"no-eval": [2],
		"no-ex-assign": [2],
		"no-extend-native": [2],
		"no-extra-bind": [2],
		"no-extra-boolean-cast": [2],
		"no-extra-parens": [2],
		"no-extra-semi": [2],
		"no-fallthrough": [2],
		"no-floating-decimal": [2],
		"no-func-assign": [2],
		"no-implicit-coercion": [2],
		"no-implicit-globals": [0],
		"no-implied-eval": [2],
		"no-inline-comments": [0],
		"no-inner-declarations": [2],
		"no-invalid-regexp": [2],
		"no-invalid-this": [0],
		"no-irregular-whitespace": [2],
		"no-iterator": [2],
		"no-label-var": [2],
		"no-labels": [0],
		"no-lone-blocks": [2],
		"no-lonely-if": [2],
		"no-loop-func": [2],
		"no-magic-numbers": [0],
		"no-mixed-requires": [0],
		"no-multi-spaces": [2],
		"no-mixed-spaces-and-tabs": [2],
		"no-multi-str": [2],
		"no-multiple-empty-lines": [2],
		"no-native-reassign": [2],
		"no-negated-condition": [0],
		"no-negated-in-lhs": [2],
		"no-nested-ternary": [2],
		"no-new-func": [0],
		"no-new-object": [2],
		"no-new-require": [0],
		"no-new-wrappers": [2],
		"no-new": [2],
		"no-obj-calls": [2],
		"no-octal-escape": [2],
		"no-octal": [2],
		"no-param-reassign": [0],
		"no-path-concat": [2],
		"no-plusplus": [0],
		"no-process-env": [2],
		"no-process-exit": [0],
		"no-proto": [2],
		"no-redeclare": [2],
		"no-regex-spaces": [2],
		"no-restricted-imports": [0],
		"no-restricted-syntax": [0],
		"no-return-assign": [2],
		"no-script-url": [2],
		"no-self-compare": [2],
		"no-sequences": [2],
		"no-shadow-restricted-names": [2],
		"no-shadow": [2],
		"no-spaced-func": [2],
		"no-sparse-arrays": [2],
		"no-sync": [0],
		"no-ternary": [0],
		"no-this-before-super": [2],
		"no-throw-literal": [2],
		"no-trailing-spaces": [2],
		"no-undef-init": [2],
		"no-undef": [2],
		"no-undefined": [0],
		"no-unexpected-multiline": [2],
		"no-unneeded-ternary": [2],
		"no-unreachable": [2],
		"no-unused-expressions": [2],
		"no-unused-vars": [2],
		"no-use-before-define": [0],
		"no-useless-call": [2],
		"no-useless-concat": [2],
		"no-var": [0],
		"no-void": [0],
		"no-with": [2],
		"no-warning-comments": [2],
		"object-shorthand": [0],
		"one-var": [0],
		"operator-assignment": [2, "always"],
		"prefer-arrow-callback": [0],
		"prefer-const": [0],
		"prefer-reflect": [0],
		"prefer-rest-params": [0],
		"prefer-spread": [0],
		"prefer-template": [0],
		"quotes": [2, "single"],
		"quote-props": [0],
		"require-yield": [0],
		"semi-spacing": [2],
		"semi": [2, "always"],
		"sort-imports": [0],
		"sort-vars": [0],
		"space-before-blocks": [2],
		"space-before-function-paren": [2, "never"],
		"space-in-parens": [2, "always"],
		"space-infix-ops": [2],
		"space-unary-ops": [2],
		"strict": [2, "safe"],
		"use-isnan": [2],
		"valid-jsdoc": [2],
		"valid-typeof": [2],
		"vars-on-top": [0],
		"wrap-iife": [2, "any"],
		"wrap-regex": [2],
		"yoda": [2]
	}
}
```

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
