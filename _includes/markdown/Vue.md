The purpose of this document is to help guide you through working with a potential project using the JavaScript framework, Vue. Outside of The [Official Vue Documentation](https://vuejs.org/), you should find here personalized recommendations for using the framework based on the types of projects we typically see at 10up. We have broken these recommendations out into common elements we tend to interact with often in client work. If something you’re looking for isn’t represented you can either submit a pull request to this repository or refer to the [Official Vue Documentation](https://vuejs.org/v2/guide/).

For Vue-specific coding style and pattern recommendations please see the official [Vue style guide](https://vuejs.org/v2/style-guide/).

## Figuring Out If Vue Is Right For Your Project

Using the right tool for the job is critical in navigating a successful project. Will Vue always be the answer? Of course not. But there are some instances where you may want to use this framework over something like (for example) a collection of plugins, custom JavaScript, or another framework.

Some questions you may want to ask yourself:
* Will this project contain a lot of components that need to interact with an API?
* Are you replicating a lot features already present in Vue like client side templating and state management?
* Will the addition of a framework save time and performance versus creating a custom solution? 
* Do your client side templates need to be accessible to a back end technology (like PHP in a WordPress template)?

If you find yourself answering, “Yes,” to those questions, Vue may be a great fit for your project or component! If not, a more traditional build may be the best.

## Implementing Vue on a Project

There are several ways to include Vue.js in your project. From the inclusion of [Vue in your HTML page](https://vuejs.org/v2/guide/installation.html#CDN) via a script tag, to [installing via NPM](https://vuejs.org/v2/guide/installation.html#NPM) and through the [Vue CLI](https://vuejs.org/v2/guide/installation.html#CLI). We will take a look at the different methods and explain when to use them.

### Script Element
The standard way to include Vue in your application is by using a `<script>` element in your HTML/PHP file just like any other JavaScript file. The Vue documentation recommends using the [official CDN](https://vuejs.org/v2/guide/installation.html#CDN) to make sure your Vue version is always up to date. 

This is the easiest way to get started and perfect for learning the framework. This is a great option if you’re building within a WordPress environment and only have a few small components to create. You may also consider this method if Vue is not the primary framework used on the project. As with any third party JavaScript inclusion, be sure to evaluate the cost/benefit of using the library/framework before starting.

If you are using Vue for isolated components within a single WordPress template be sure to enqueue the script as you normally would for only that instance as to not load Vue where you don’t need it. If you are using Vue throughout a project it is best to concatenate it alongside all your other JavaScript files.

### Including with NPM

[NPM](https://vuejs.org/v2/guide/installation.html#NPM) is the recommended installation method when building NPM-enabled applications with Vue. This method of installation is recommended for Vue-based applications when you want more custom and fine-grained control over the dependencies being used. You might also consider using this method when a project is taking advantage of NPM as a front-end package manager.

### Installing with a CLI

The [Vue CLI](https://vuejs.org/v2/guide/installation.html#CLI) provides us a quick way to setup and scaffold a Vue project. It makes use of the modern frontend workflows and out of the box, vue-CLI provides hot reloading, minification, asset management, module bundling, linting and a development server to test your application under realistic circumstances. It works with zero configuration from your part as everything is already set up in the [vue-CLI templates](https://github.com/vuejs-templates/). 

The CLI caters from the most simple app ([the simple template](https://github.com/vuejs-templates/simple)), to the most complex one ([Webpack](https://github.com/vuejs-templates/webpack) ). This is the recommended way to install Vue when you’re building a single page application (not a WordPress theme) that runs off an API and will be using the Vue framework exclusively. The CLI will likely need to be used and implemented at the beginning of a project.


## Events

Vue provides us with an easy way to react to user interaction and DOM events on our site through the use of events. Events are setup through adding `v-on:eventname="method"` as an attribute on the HTML element that you would like the event captured for. View the official documentation for a [list of supported DOM events](https://developer.mozilla.org/en-US/docs/Web/Events).

### Event Modifiers

[Event modifiers](https://vuejs.org/v2/guide/syntax.html#Modifiers) allow you to separate function logic from the DOM by leaving things like event propagation, scope event bindings, and prevent default behaviors without writing it into the JavaScript method. Vue best practice dictates to use these event modifiers instead of coding into the function directly to better maintain the DOM/Logic separation.

### Key Events

When binding to a key event such as keyup, Vue gives us key modifiers to specify which key to listen for through their key code or shorthand name. For instance `<input type="text" v-on:keypress.enter="addItem">` will run the addItem method each time the enter key is pressed. This should be used with Key events so this information can stay out of the JavaScript methods.

### Shorthand Syntax

[Shorthand properties](https://vuejs.org/v2/guide/syntax.html#Shorthands) exist in Vue, to tighten up the HTML display when it can feel unnecessary to specifically call out each item as a Vue interaction. The framework specifically provides shorthand options for two of the most popular directives: `v-on` (events), and `v-bind` (attribute bindings).

This allows you to specify events through the use of `@`. That replaces v-on: and would look like this `<button @click="submit">`. 

If you are using Vue within a larger context you should try an avoid using shorthand properties as they can easily get lost in the HTML. However, if your project is a single page application and heavily using Vue, it may feel redundant to continuously preface these directives with `v-`, in that case you should use shorthand. You can [read more about shorthand properties](https://vuejs.org/v2/guide/syntax.html#Shorthands) in the official Vue documentation.

## Templating and Components
There are three main styles of templating built into the Vue framework:

* Using a script block or inline template in the HTML (similar to Mustache or Handlebars)
* JavaScript inline template strings (Similar to React)
* Using an external `.vue` template file

Of the three major options, which one you utilize will heavily depend on the type of project you’re building.

If you are building small components that consume API data and do not need information from a WordPress template you can use your best judgement on whether the template references should remain in the HTML template or in the component JavaScript file. This is called an, “[inline template string](https://vuejs.org/v2/guide/components.html#Passing-Data-with-Props),” and you can easily pass data into the template through [props](https://vuejs.org/v2/guide/components.html#Props).

If you are integrating your templating with WordPress templates and back end engineering, we recommend using a script block that is embedded into the HTML template so back and front end engineers can use the output as a point of reference and easily work on the project within their discipline. [Read more about inline templates](https://vuejs.org/v2/guide/components.html#Inline-Templates).

However, if you are building a single page application with Vue, it is recommended that each project module be componentize within a `.vue` template file. All JavaScript, CSS, and HTML templates would be scoped together.  For this, you will also likely use the [Vue CLI](https://vuejs.org/v2/guide/installation.html#CLI) to initialize your project. These are called “[Single File Components](https://vuejs.org/v2/guide/single-file-components.html).”

If you are using Vue outside of the SPA context make sure all your features have non-JS fallback behaviors so nothing appears broken if JavaScript fails to load.

[Read more about creating Vue Components](https://vuejs.org/v2/guide/components.html)

[Read more about choosing the right template style in Vue](https://sebastiandedeyne.com/posts/2016/dealing-with-templates-in-vue-20)


## Resources and Official Documentation

* [Installation](https://vuejs.org/v2/guide/installation.html)
* [Events](https://vuejs.org/v2/guide/events.html)
* [Transitions](https://vuejs.org/v2/guide/transitions.html)
* [Creating Transition and Animations](https://css-tricks.com/creating-vue-js-transitions-animations/)
* [Templating](https://vuejs.org/v2/guide/syntax.html)
* [State Management](https://vuejs.org/v2/guide/state-management.html)
* [Style Guide](https://vuejs.org/v2/style-guide/)

