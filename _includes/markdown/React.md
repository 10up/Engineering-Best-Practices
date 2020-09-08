The purpose of this document is to help guide you through working with a potential project using the JavaScript library, [React](https://reactjs.org/). Outside of the official React documentation, you should find here personalized recommendations for using the library based on the types of projects we typically  see at 10up. We have broken these recommendations out into common elements we tend to interact with often in client work. If something you’re looking for isn’t represented you can either submit a pull request to this repository or refer to the [official React documentation](https://reactjs.org/).

## Figuring Out If React Is Right For Your Project

Using the right tool for the job is critical in navigating a successful project. Will React always be the answer? Of course not. But there are some instances where you may want to use this library over something like (for example) a collection of plugins, custom JavaScript, or another framework.

When deciding whether React is the right tool for your project, it might help to ask the following questions:

* Will this project involve building a user interface that requires statefulness? In other words, will your user interface need to...react...in real time to user actions or changeable data coming from an API?
* Does your project need enough reusable components to make it worth using React? React is a fairly heavy library compared with the similar Vue.
* Will your project need to render large amounts of data in real time while remaining performant for the browser?
* Are you building a native mobile app for iOS and/or Android? The React team also maintains React Native, a subset of React which makes it possible to write applications in JavaScript using React components that compile to native Swift and Java.

React is easily integrated into specific parts of the front-end or admin of an existing site, but it can also be used to render entire sites, effectively replacing traditional WordPress templates—although doing so requires a lot more planning and scaffolding of features (such as routing) that would normally be handled by the CMS out of the box.

## Components
When building out components, it's beneficial to understand how to construct them in the most appropriate way possible. Certain "types" of components can be written differently which can have big performance benefits on larger scale applications.

### Class Components
Class Components are written in the ES6 Class syntax. When building a component using a [JS Class](https://reactjs.org/docs/react-api.html#reactcomponent), you are generally inferring that the component manages it's own `state` or needs access to specific lifecycles hooks.

Example of a Class Component:

```javascript
import React, { Component } from 'react';

class SearchInput extends Component {
	constructor(props) {
		super(props);
		this.state = {
			searchTerm: '',
		};
		this.handleClick = this.handleClick.bind(this);
	}

	handleClick(e) {
		this.setState({ searchTerm: e.target.value });
	}

	render() {
		const { searchTerm } = this.state;
		return (
			<div className="search-input">
				<input onChange={this.handleClick} value={searchTerm} />
			</div>
		);
	}
}

export default SearchInput;
```

Using class components are mostly discouraged since the introduction of [React Hooks](https://reactjs.org/docs/hooks-intro.html). There are however some situations where you might still need a class component:

- When you need access to a very specific lifecycle hook such as `componentDidCatch` for creating [ErrorBoundaries](https://reactjs.org/docs/error-boundaries.html#introducing-error-boundaries).
- Some components are naturally better suited for using class components. As an example consider the following component that consumes a stream of frames:

```javascript
import React, { Component } from 'react';

class Camera extends Component {
	handleCameraStream = (frames) => {
		// this method has proper access to props and state. Even if Camera re-renders.
		cancelAnimationFrame(this.rafID);
		const loop = async (now) => {
			const frame = frames.next().value;
			// process frame
			this.rafID = requestAnimationFrame(loop);
		};
		this.rafID = requestAnimationFrame(loop);
	};

	render() {
		return <CameraStream width={width} height={height} onReady={this.handleCameraStream} />;
	}
}

export default Camera;
```

`onReady` is only called when the camera stream is ready and the `handleCameraStream` method sets up a loop, if `Camera` re-renders, `onReady` is not called again. If `Camera` was a functional component, everytime it re-rendered and its props/state changed, the `handleCameraStream` callback would not have the right scope to have access to the most up-to-date state/props as the function was bound to the first render. The alternative for using functional components is storing each frame in state through `useState` and process frames in a separate function but that adds complexity and unecessary re-renders every time a new frame is received.

### Functional Components

A Functional Component can take the form of a [plain function](https://reactjs.org/docs/components-and-props.html#function-and-class-components) in JavaScript, or a fat arrow function stored in a variable. In the past, the biggest difference between a Class Component and a Functional Component was that Functional Components were not aware of `state`. With the introduction of [React Hooks](https://reactjs.org/docs/hooks-intro.html) functional components are now able to handle most of the React APIs such as state, contexts, refs and lifecycle.

Functional components are the **recommended** way to write React components as they come with less boilerplate code, allows you to reuse stateful logic without changing component hierarchy and complex components become easier to understand by avoiding a myriad of complex logic spread between `componentDidUpdate`, `componentDidMount` and other lifecycle class methods. 

The following example is the previous `SearchInput` component converted to a functional component using hooks.

```javascript
import React, { useState } from 'react';

const SearchInput = () => {
	const [searchTerm, setSearchTerm] = useState('');

	const handleClick = (e) => {
		setSearchTerm(e.target.value);
	};

	return (
		<div className="search-input">
			<input onChange={handleClick} value={searchTerm} />
		</div>
	);
};

export default SearchInput;
```

### PureComponents

PureComponents allow for a potential performance benefit. A [Pure Component](https://reactjs.org/docs/react-api.html#reactpurecomponent) implements the `shouldComponentUpdate` lifecycle method to perform a shallow comparison of what changed in `props` and `state` since the last render.

Considering PureComponents perform shallow comparisons of previous `state` and new `state`, a component should become "pure" when theres no need to re-render the entire component (or its children) every time data changes. 

Typically, you **won't need** to create PureComponents as functional components and react hooks are better tools for the job. Do not use PureComponent if you are building stateless functional component and need lifecycle methods, use the `useEffect` hook instead. 

*NOTE:* The performance benefits are realized when the data passed to the component is simple. Large nested objects, and complex arrays passed to PureComponents may end up degrading the performance benefits. It's important to be very deliberate about your use of this type of component.


## Routing

In most cases, you will only need routing if your React application needs to navigate between multiple layout components, render different data based on the current app location, and provide browser history. Make sure your app needs routing functionality before you consider adding a routing library.

### React Router

The most popular routing library for React is [React Router](https://github.com/ReactTraining/react-router). React Router provides a core library plus APIs for both DOM (web) and React Native (native iOS and Android) platforms. To use the library, install the package for one or the other API according to your application’s platform needs—the core library is included in both.

To read more about the concept of dynamic routing, with plenty of code examples to follow along with, refer to the [React Router documentation](https://reacttraining.com/react-router/web/guides/philosophy).

### Routing Accessibility

In general, routing is little more than an Ajax call to load content with a URL update. This pattern poses some accessibility problems since there is no true page reload. To overcome this and make sure our React implementations pass accessibility compliance we need to ensure a few things happen:

1. Update the page title.
2. Programmatically [reassign focus with a ref](https://reactjs.org/docs/refs-and-the-dom.html) to the new loaded content.
3. [Alert the user of any changes](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Live_Regions) (like a new page loading).

Following these steps will make sure your content and routing is readable by assistive technology.

## Props and State

State in React is the lifeblood of the component. State determines how, and with what data, a component will be rendered on the page. State gives components reactivity and dynamic rendering abilities.

Props serve as a means to pass data between components. At its most basic level, props are passed to *each individual component* that needs to consume and utilize that data. Basic applications will likely be able to pass data using this default behavior.

### State Management

As an application becomes more complex, it may become more of a hassle to pass data down to many child components. This is where frameworks like [Redux](https://redux.js.org/) will come in. However before you reach for these third party frameworks, consider the [React Context API](https://reactjs.org/docs/context.html)

#### Context API

The React Context API is the first line of defense when your application becomes sufficiently complex, and we are faced with [prop drilling](https://kentcdodds.com/blog/prop-drilling) concerns.

Context provides a way to pass data through the component tree without having to pass props down manually at every level. This is immensely helpful for applications that are highly componentized, and need to share data with those components, regardless of where they exist within the application structure. It is crucial that you think critically about how the data in your application is to be utilized and passed around. If data simply needs to be shared, Context may be for you.

Context does not however provide the further sophisticated features of libraries like Redux. Stepping through application history, alternate UIs that reuse business logic, state changes based on actions etc. If those are things that you need in your application, the Context API may not be quite robust enough for you. 

You also need to be careful with the fact that any component "connected" to a given React Context will re-render automatically when the data the context holds changes. There's no built-in mechanism to **mapStateToProps** within the Context API. One way to solve this problem is to create multiple specialized contexts for you application that only stores a specific portion of you shared global state. For example, a "User" context that holds user data and a "Posts" context that holds a list of posts to be rendered on the application.

For example, consider the following `UserProvider` component that is responsible for fetching an user if it's logged in and storing the user object in a React Context.

```javascript
import React, { useEffect, useState, useContext, createContext } from 'react';
import PropTypes from 'prop-types';
import { fetchUser } from '../util';

export const UserContext = createContext();

export const useUser = () => {
	const data = useContext(UserContext);

	return data.user ? data.user : null;
};

const UserProvider = ({ children }) => {
	const [user, setUser] = useState(null);

	useEffect(() => {
		fetchUser().then(setUser);
	}, []);

	return <UserContext.Provider value={{ user }}>{children}</UserContext.Provider>;
};

UserProvider.propTypes = {
	children: PropTypes.oneOfType([PropTypes.element, PropTypes.arrayOf(PropTypes.element)])
		.isRequired,
};

export default UserProvider;
```

This component can then wrap the application tree exposing the `UserContext` to any child component.

```javascript
import React from 'react';
import UserProvider, { useUser } from './UserProvider';

const UserMenu = () => {
	const user = useUser();

	return user ? 'user is logged in' : 'user is not logged in';
};

const App = () => (
	<UserProvider>
		<UserMenu />
	</UserProvider>
);

export default App;
```


#### Redux

As an application grows larger, it may be the case where the state becomes difficult to handle, every new feature introduces a new layer of complexity that may in some cases result in unexpected, and unpredictable behavior.

Redux is a state container that stops the ever-changing nature of the state itself. It acts as a protector of the state, allowing only certain defined actions to trigger a state update. Thus making it predictable.

**Principles of Redux**

Redux is based almost completely on 3 main principles:

1. Single Source of Truth: This is a main tree object which holds the entire state of your application. It’s meant to help your application to be seen as a whole.
2. State is Read Only: The state of the application stops being mutable, the only way to change the state is by triggering an action, which itself will work as a log of what, when, and why changed in the state.
3. Changes are made with pure functions: This means that only an action (or an event) can trigger a Reducer which will take the previous state and return a new one.

The third bullet point is really important but some times underestimated. Introducing application side-effects inside reducers can trigger several issues that become difficult to debug. As a general rule, action creators and reducers should never trigger application side-effects such as mutating the DOM, attaching event callbacks, triggering event callbacks etc. If you need something like that consider either creating a Redux Middleware or using existing solutions such as [Redux Saga](https://redux-saga.js.org/) alongside with Redux.

**When to use Redux**

As appealing as it might be. Redux is not a tool for everyday use. By design, Redux will put constraints in your application that may not actually be needed. A good starting point to make this choice is the article by its creator, [Dan Abramov: You might not need Redux](https://medium.com/@dan_abramov/you-might-not-need-redux-be46360cf367). The usual recommendation is, think in React. And if along the way you discover the need of Redux, implement it.

## Resilient Components

The idea of resilient components was first introduced by Dan Abramov, his blog post [writing resiliting components](https://overreacted.io/writing-resilient-components/) does a great job explaining this concept.

The principes are the following:

1. [Don’t stop the data flow](https://overreacted.io/writing-resilient-components/#principle-1-dont-stop-the-data-flow)
2. [Always be ready to render](https://overreacted.io/writing-resilient-components/#principle-2-always-be-ready-to-render)
3. [No component is a singleton](https://overreacted.io/writing-resilient-components/#principle-3-no-component-is-a-singleton)
4. [Keep the local state isolated](https://overreacted.io/writing-resilient-components/#principle-4-keep-the-local-state-isolated)

Writing resilient components makes components more robust and has the potential to avoid many bugs. It's highly recommended to review the principles above.

## Accessibility

React accessibility is not so different than standard accessibility support. It mainly centers around making sure semantic HTML and proper attributes are used with the correct elements. Managing focus flow and repairing when necessary. Be sure to also use the [jsx-a11y eslint plugin](https://github.com/evcohen/eslint-plugin-jsx-a11y) to ensure your code maintains a solid accessible foundation.

### Semantic HTML and Fragments

Using the the most relevant HTML elements is always preferred, and doesn’t change when using React. Sometimes we can break HTML semantics when we add div elements to our JSX to make our React code work, especially with a set of elements such as lists. In these cases we should use Fragments.

[Fragments](https://reactjs.org/docs/accessibility.html/#semantic-html) are a pattern used in React which allow a component to return multiple elements, without an encompassing div component. Using div elements in certain contexts may break HTML semantics.
Use fragment when a key prop is required
Use `<elem></elem>` syntax everywhere else

### Accessible Forms
Standard HTML practices should be used for forms. One caveat though is making sure all inputs have proper labeling. In React the `“for”` attribute is written as `“htmlFor”` in JSX.
```
<label htmlFor="namedInput">Name:</label>
<input id="namedInput" type="text" name="name"/>
```

### Programmatically managing focus

React applications continuously modify the HTML DOM during runtime, sometimes leading to keyboard focus being lost or set to an unexpected element. React provides “Refs” in order to modify child components or elements outside of the standard flow. These can help us specifically manage keyboard focus.

The ref attribute can be placed on any React component, with a function value. This function will be executed as soon as the component is mounted or unmounted. The first parameter of the function will be a reference to the element or the component the ref is on.

[Read more about creating refs and focus control in React](https://reactjs.org/docs/accessibility.html#focus-control)

## Server Side Rendering

With server side rendering (SSR), the initial content is generated on the server, so your browser can download a page with HTML content already in place. Updates to the content are still handled in the browser.

Here are three topics to consider when looking at server-side rendering:
* [SEO](https://www.javascriptstuff.com/server-side-render/#seo): Rendering server-side helps search engine crawlers find your content, but sometimes Google can find your content without SSR.
* [Performance](https://www.javascriptstuff.com/server-side-render/#performance): SSR will usually increase performance for your app, but not always.
* [Complexity](https://www.javascriptstuff.com/server-side-render/#complexity): Using SSR will increase the complexity of your application, which means less time working on other features and improvements.

### When to Use Server-side Rendering

* You need SEO on Google, DuckDuckGo, Bing, Yahoo, or Baidu and performing consistently across all of them. Note that as of now, Google and Bing can index synchronous JavaScript applications—synchronous being the key word. If your app starts with a loading spinner, then fetches content via Ajax, the crawler will only wait a few seconds for loading to complete. This means if you have content fetched asynchronously on pages where SEO is important, SSR might be necessary.
* If you are looking for an alternative to improve user experience and performance. Server-rendered markup doesn't need to wait until all JavaScript has been downloaded and executed to be displayed, so your user will see a fully-rendered page sooner. This generally results in better user experience, and can be critical for applications where time-to-content is directly associated with conversion rate.

### Other things to consider when using SSR:

* Issues might arise when using SSR with third-party libraries, which to render the components need to access certain variables that are only available in the browser (for e.g window, document...).
* Rendering a full app in Node.js is obviously going to be more CPU-intensive than just serving static files, so if you expect high traffic, be prepared for corresponding server load and wisely employ caching strategies.

### Prerendering
If you're only investigating SSR to improve the SEO of a handful of marketing pages, you probably want [prerendering](https://github.com/geelen/react-snapshot) instead. Rather than using a web server to compile HTML on-the-fly, prerendering simply generates static HTML files for specific routes at build time. The advantage is setting up prerendering is much simpler and allows you to keep your frontend as a fully static site.

### Dynamic Rendering

Another alternative for improving SEO on react websites without SSR is to use [Dynamic Rendering](https://developers.google.com/search/docs/guides/dynamic-rendering). This requires a more complex set up but the benefit is that this technique does not require any changes to the SPA codebase.

The idea here is to set up a server or service that will be responsible for prerendering the SPA through a headless browser before serving the markup to search engines.

## Debugging
React provides a Chrome &amp; Firefox extension to facilitate debugging. It is an extremely useful debugging tool, providing quick transparent access into the data within your React instance. Whenever you encounter a new concept in React, it’s generally a good idea to open up the dev tool, and observe your application state.

## Gutenberg
Before we dive into some of the specifics of Gutenberg, it's important to understand React's role within Gutenberg itself.

Very simply, Gutenberg is built with React. The underlying code that makes Gutenberg work, is React code. Much like “WordPress PHP” Gutenberg blocks employ a similar code style as React, but it’s not React. In any case, the most effective way for us to frame React’s role in Gutenberg is that React is simply the technology used to make Gutenberg work the way it does.

### Framing Gutenberg
When discussing Gutenberg and its capabilities, we must examine its role in any given project. Primarily, Gutenberg should be framed as a tool for publishers to manage their content in a more dynamic and flexible way. It should not be framed as a "page builder", which implies a 1:1 relationship between the front end and the back end. Gutenberg most certainly has tools to help us achieve a 1:1 relationship, however creating this relationship for every custom block should not be an implied expectation.

### Gutenberg Components
When creating Gutenberg components in the WordPress editor, mostly you’ll find yourself adhering to the standard best practices of React, but there are a few Gutenberg-specific design patterns you should be aware of before starting a new build.

#### @wordpress/element
Element is an abstraction layer atop React created just for WordPress and used within Gutenberg components. It was created to allow engineers an API entry point into Gutenberg with deliberate features, omissions, and protections from core-library updates (React updates, in this case) that could cause breaking changes in an interface.

The presence of Element is why you don't see React directly imported into Gutenberg components. [Read more about using Element in Gutenberg](https://wordpress.org/gutenberg/handbook/designers-developers/developers/packages/packages-element/).

#### Higher-order Components
Gutenberg offers a library of higher-order components (HOC) you can use to build out a robust editor experience. The features of these components range from focus management to auditory messaging. It is best to familiarize yourself with these components so you don't end up rebuilding a utility functionality that already exists within Gutenberg. You can view [Gutenberg's library of generic Higher Order React Components](https://github.com/WordPress/gutenberg/tree/master/packages/components/src/higher-order) to learn more or view the official [React documentation for general information about using HOC](https://reactjs.org/docs/higher-order-components.html).

As with any evolving feature, it is important to frequently check the documentation for new additions and updates.

### Including / Excluding Blocks

Gutenberg has the ability to allow only certain blocks to be used. This can be found under the [Block Filters](https://developer.wordpress.org/block-editor/developers/filters/block-filters/) page of the official Gutenberg documentation. Specifically, under the heading [Removing Blocks](https://developer.wordpress.org/block-editor/developers/filters/block-filters/#removing-blocks). Details of how to filter via JavaScript or PHP can be found there.

Also note that this method is different than the `allowedBlocks` prop on `<InnerBlocks>` when used in a custom block. The filtering described here applies to all blocks on a higher level within the editor.

#### Possible scenarios

There may be a need to remove or restrict access to blocks. This could be for a variety of reasons, but typical scenarios could be:
- Improve admin UX by reducing block options for editors
- Prevent editors from using unsupported blocks
- Multiphase / retainer project where a subset of blocks are added / supported over time
- Restricting blocks to a particular user group, post type, or page template
- Using a custom block which replaces functionality of an existing block

Each project is different. Carefully consider removing blocks from the admin with your project team.

#### Choosing to allow or deny access to blocks

Typically, you should exclude all blocks by default and add a list of which blocks to include versus including all blocks by default with a list of which to exclude. This helps guard against changes or blocks which are added at a later date, which could break functionality or have other unintented side effects. Blocks would have to be specifically allowed and tested before being used. Additionally, typical patterns for how we develop favor this in other locations (such as escaping, `<InnerBlocks>`, etc.) This helps keep a consistent pattern in the codebase.
