The purpose of this document is to help guide you through working with a potential project using the JavaScript library, [React](https://reactjs.org/). Outside of The official React documentation, you should find here personalized recommendations for using the library based on the types of projects we typically  see at WisdmLabs. We have broken these recommendations out into common elements we tend to interact with often in client work. If something you’re looking for isn’t represented you can either submit a pull request to this repository or refer to the [official React documentation](https://reactjs.org/).

## Figuring Out If React Is Right For Your Project

Using the right tool for the job is critical in navigating a successful project. Will React always be the answer? Of course not. But there are some instances where you may want to use this library over something like (for example) a collection of plugins, custom JavaScript, or another framework.

When deciding whether React is the right tool for your project, it might help to ask the following questions:

* Will this project involve building a user interface that requires statefulness? In other words, will your user interface need to...react...in real time to user actions or changeable data coming from an API?
* Does your project need enough reusable components to make it worth using React? React is a fairly heavy library compared with the similar Vue.
* Will your project need to render large amounts of data in real time while remaining performant for the browser?
* Are you building a native mobile app for iOS and/or Android? The React team also maintains React Native, a subset of React which makes it possible to write applications in JavaScript using React components that compile to native Swift and Java.

React is easily integrated into specific parts of the front-end or admin of an existing site, but it can also be used to render entire sites, effectively replacing traditional WordPress templates—although doing so requires a lot more planning and scaffolding of features (such as routing) that would normally be handled by the CMS out of the box.

## Implementing React on a Project

There are a number of ways to get up and running with React in a project. The deciding factor is based on the context of your project and how you plan to implement React. The following subsections will outline instructions that are specific to installing React on a per project basis:

### Script Element

Including React via a script element in your HTML is a pretty quick and standard way of including the library. To do this you can either [download the library directly](https://react-cn.github.io/react/downloads.html), use the [CDN](https://reactjs.org/docs/cdn-links.html), or install through [NPM](https://www.npmjs.com/package/react) and direct-link into your `node_modules` directory.

Something to note about this method is that React and ReactDOM are both required. There is also no inherent support for ES6 or JSX without Webpack or Babel in this context. You would need to separately configure a transpiler or write in Vanilla JavaScript.

### Including with NPM

If you already have a Node / NPM / Yarn project that you wish to include React as a dependency of, then you can use the installation instructions found on the [Official React Documentation](https://reactjs.org/docs/add-react-to-an-existing-app.html). Include React and ReactDOM in your package file just like you would any other dependency. Also be sure your transpiler is working to correctly process the ES6 and JSX from React into something the browser can understand.

### Installation with a CLI

[The React CLI](https://reactjs.org/blog/2016/07/22/create-apps-with-no-configuration.html) (create-react-app) provides us a quick way to setup and scaffold a React project. It makes use of the modern frontend workflows and out of the box, React CLI provides hot reloading, minification, asset management, module bundling, linting and a development server to test your application under realistic circumstances. It works with zero configuration from your part as everything is already set up.

Using the CLI tool is ideal if you are creating a full React App with an API backend.

## Routing

In most cases, you will only need routing if your React application needs to navigate between multiple layout components, render different data based on the current app location, and provide browser history. Make sure your app needs routing functionality before you consider adding a routing library.

The most popular routing library for React is [React Router](https://github.com/ReactTraining/react-router). React Router provides a core library plus APIs for both DOM (web) and React Native (native iOS and Android) platforms. To use the library, install the package for one or the other API according to your application’s platform needs—the core library is included in both.

*Best practice recommendation:* Build the app components without routing first, then add routing once the navigation structure is clear, so that you’re not locked into a routing configuration at the outset which might not match your application’s final structure.
To read more about the concept of dynamic routing, with plenty of code examples to follow along with, refer to the [React Router documentation](https://reacttraining.com/react-router/web/guides/philosophy).

## State Management

State in React is the lifeblood of the component. State determines how, and with what data, a component will be rendered on the page. State gives components reactivity and dynamic rendering abilities.

### Managing State within React

State is managed within each individual component. Generally, state should not be passed between components, as state is intended to determine how a single component is rendered on the page.

On initial render of a component, we are able to define default state. This default state will be made available to the component on it’s initial render, before a user, or any method mutates the state. This is typically defined within the initial constructor() method of a react component. Check out the React docs for an example showing how to set initial state.

### Updating State

State is made to be updated (or mutated), either by methods within the component that take input from the user, or methods created by you to mutate the state manually. Either way, it requires utilization of the setState() method. Examples of the various ways to update state can be found in the React documentation.

It’s important to note, that when updating state, you should never update it directly. The only place you can assign this.state is the constructor. Updating it directly will not trigger the component to re-render.

## Redux

As an application grows larger, it may be the case where the state become difficult to handle, every new feature introduces a new layer of complexity that may in some cases result in unexpected, and unpredictable behavior.

Redux is a state container that stops the ever-changing nature of the state itself. It acts as a protector of the state, allowing only certain defined actions to trigger a state update. Thus making it predictable.

### Principles of Redux

Redux is based almost completely on 3 main principles:

1. Single Source of Truth: This is a main tree object which holds the entire state of your application. It’s meant to help your application to be seen as a whole.
2. State is Read Only: The state of the application stops being mutable, the only way to change the state is by triggering an action, which itself will work as a log of what, when, and why changed in the state.
3. Changes are made with pure functions: This means that only an action (or an event) can trigger a Reducer which will take the previous state and return a new one.

### When to use Redux

As appealing as it might be. Redux is not a tool for everyday use. By design, Redux will put constraints in your application that may not actually be needed. A good starting point to make this choice is the article by its creator, [Dan Abramov: You might not need Redux](https://medium.com/@dan_abramov/you-might-not-need-redux-be46360cf367). The usual recommendation is, think in React. And if along the way you discover the need of Redux, implement it.

## Accessibility

React accessibility is not so different than standard accessibility support. It mainly centers around making sure semantic HTML and proper attributes are used with the correct elements. Managing focus flow and repairing when necessary.

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
* If your project has a generous budget and can be deployed on a NodeJS server.

### Other things to consider when using SSR:

* Issues might arise when using SSR with third-party libraries, which to render the components need to access certain variables that are only available in the browser (for e.g window, document...).
* Rendering a full app in Node.js is obviously going to be more CPU-intensive than just serving static files, so if you expect high traffic, be prepared for corresponding server load and wisely employ caching strategies.

### Prerendering
If you're only investigating SSR to improve the SEO of a handful of marketing pages, you probably want [prerendering](https://github.com/geelen/react-snapshot) instead. Rather than using a web server to compile HTML on-the-fly, prerendering simply generates static HTML files for specific routes at build time. The advantage is setting up prerendering is much simpler and allows you to keep your frontend as a fully static site.

## Debugging
React provides a Chrome &amp; Firefox extension to facilitate debugging. It is an extremely useful debugging tool, providing quick transparent access into the data within your React instance. Whenever you encounter a new concept in React, it’s generally a good idea to open up the dev tool, and observe your application state.

