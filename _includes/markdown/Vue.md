The purpose of this document is to help guide you through working with a project using the JavaScript framework, Vue. Outside of the [official Vue Documentation](https://vuejs.org/), you will  find here personalized recommendations for using the framework based on the types of projects we typically see at 10up. We have broken these recommendations out into common elements we tend to interact with often in client work. If something you’re looking for isn’t represented you can either submit a pull request to this repository or refer to the [official Vue Documentation](https://vuejs.org/).

For Vue-specific coding style and pattern recommendations please see the official [Vue style guide](https://vuejs.org/v2/style-guide/).

## Figuring Out If Vue Is Right For Your Project

Using the right tool for the job is critical in navigating a successful project. Vue won’t always be the right tool to reach for, but there are some instances where you may want to use this framework over a collection of plugins, custom JavaScript, or another framework.

Some questions you may want to ask yourself:
* Will this project contain a lot of components that need to interact with an API?
* Are you replicating a lot of features already present in Vue, like client-side templating, state management, communication between components?
* Will adding Vue save time and performance versus creating a custom solution?
* Are you creating an application-like feature nested inside the context of a larger build?
* Do you need to easily integrate a modern application within an older code base?
* Do your client-side templates need to be easily accessible to a back end technology (like PHP in a WordPress template)?


If you find yourself answering, “Yes,” to those questions, Vue may be a great fit for your project or component! If not, a more traditional build may be the best.

While we tend to build large-scale applications with [React]({{ site.baseurl }}/react) at 10up, Vue is a great tool for building small to medium sized features. 

## Implementing Vue on a Project

There are several ways to include Vue.js in your project. We will take a look at the different methods and explain when to use them.

### Script Element
The standard way to include Vue in your application is by using a `<script>` element in your HTML/PHP file just like any other JavaScript file. The Vue documentation recommends using the [official CDN](https://vuejs.org/v2/guide/installation.html#CDN) to make sure your Vue version is always up to date.

This is the easiest way to get started. It is a great option if you’re building within a WordPress environment and only have a few small components to create. You may also consider this method if Vue is not the primary framework used on the project. As with any third-party JavaScript inclusion, be sure to evaluate the cost/benefit of using a library or framework before starting.

If you are using Vue for isolated components within a single WordPress template, be sure to enqueue the script as you normally would for only that instance. You don’t want to load Vue across the entire site, if you don’t need to. If you are using Vue throughout a project it’s best to concatenate it alongside all your other JavaScript files.

### Including with NPM

[Npm](https://vuejs.org/v2/guide/installation.html#NPM) is the recommended installation method when building npm-enabled and ES6+ applications with Vue. This method of installation gives you more fine-grained control over the dependencies being used via the `package.json` file. Keeping dependencies in the `package.json` file also serves as a quick reference to any engineers during a project onboarding period.

[View the official documentation about installing Vue via npm](https://vuejs.org/v2/guide/installation.html#NPM).

### Installing via the CLI

The [Vue CLI](https://vuejs.org/v2/guide/installation.html#CLI) provides us a quick way to setup and scaffold a Vue project. It sets up a modern frontend workflow providing hot reloading, minification, asset management, module bundling, linting and a development server to test your application under realistic circumstances. It works with zero configuration from your part as everything is already set up in the [vue-CLI templates](https://github.com/vuejs-templates/).

Using the CLI is a more “Vue-centric” approach, and makes sense if you’re building a full Javascript application. Projects at 10up tend to be more “WordPress-centric”, and typically already have their own build process established by the time Vue gets added.

Although we probably won't use Vue in this context, as we tend to build larger applications at 10up using [React]({{ site.baseurl }}/react), it is still important to know that it does exist and the patterns can help guide you in creating a meaningful structure for your project.

## Templating and Components
There are three main styles of templating built into the Vue framework:

* Using a script block or inline template in the HTML (similar to Mustache or Handlebars)
* JavaScript inline template strings (Similar to React)
* Using an external .vue template file

Which of these three options you utilize will heavily depend on the type of project you’re building.

If you are building small components that consume API data and do not need information from a WordPress template you can use your best judgement on whether the template references should remain in the HTML template or in the component JavaScript file. This is called an, “inline template string,” and you can easily pass data into the template through props.

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
