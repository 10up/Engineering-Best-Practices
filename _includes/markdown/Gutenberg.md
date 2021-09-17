Before we dive into some of the specifics of Gutenberg, it's important to understand React's role within Gutenberg itself.

Very simply, Gutenberg is built with React. The underlying code that makes Gutenberg work, is React code. Much like “WordPress PHP” Gutenberg blocks employ a similar code style as React, but it’s not React. In any case, the most effective way for us to frame React’s role in Gutenberg is that React is simply the technology used to make Gutenberg work the way it does.

<h2 id="framing-gutenberg" class="anchor-heading">Framing Gutenberg {% include Util/link_anchor anchor="framing-gutenberg" %} {% include Util/top %}</h2>
When discussing Gutenberg and its capabilities, we must examine its role in any given project. Primarily, Gutenberg should be framed as a tool for publishers to manage their content in a more dynamic and flexible way. It should not be framed as a "page builder", which implies a 1:1 relationship between the front end and the back end. Gutenberg most certainly has tools to help us achieve a 1:1 relationship, however creating this relationship for every custom block should not be an implied expectation.

<h2 id="gutenberg-components" class="anchor-heading">Gutenberg Components {% include Util/link_anchor anchor="gutenberg-components" %} {% include Util/top %}</h2>
When creating Gutenberg components in the WordPress editor, mostly you’ll find yourself adhering to the standard best practices of React, but there are a few Gutenberg-specific design patterns you should be aware of before starting a new build.

### @wordpress/element
Element is an abstraction layer atop React created just for WordPress and used within Gutenberg components. It was created to allow engineers an API entry point into Gutenberg with deliberate features, omissions, and protections from core-library updates (React updates, in this case) that could cause breaking changes in an interface.

The presence of Element is why you don't see React directly imported into Gutenberg components. [Read more about using Element in Gutenberg](https://wordpress.org/gutenberg/handbook/designers-developers/developers/packages/packages-element/).

### Higher-order Components
Gutenberg offers a library of higher-order components (HOC) you can use to build out a robust editor experience. The features of these components range from focus management to auditory messaging. It is best to familiarize yourself with these components so you don't end up rebuilding a utility functionality that already exists within Gutenberg. You can view [Gutenberg's library of generic Higher Order React Components](https://github.com/WordPress/gutenberg/tree/master/packages/components/src/higher-order) to learn more or view the official [React documentation for general information about using HOC](https://reactjs.org/docs/higher-order-components.html).

As with any evolving feature, it is important to frequently check the documentation for new additions and updates.

<h2 id="inc-excl-blocks" class="anchor-heading">Including / Excluding Blocks {% include Util/link_anchor anchor="inc-excl-blocks" %} {% include Util/top %}</h2>

Gutenberg has the ability to allow only certain blocks to be used. This can be found under the [Block Filters](https://developer.wordpress.org/block-editor/developers/filters/block-filters/) page of the official Gutenberg documentation. Specifically, under the heading [Removing Blocks](https://developer.wordpress.org/block-editor/developers/filters/block-filters/#removing-blocks). Details of how to filter via JavaScript or PHP can be found there.

Also note that this method is different than the `allowedBlocks` prop on `<InnerBlocks>` when used in a custom block. The filtering described here applies to all blocks on a higher level within the editor.

### Possible scenarios

There may be a need to remove or restrict access to blocks. This could be for a variety of reasons, but typical scenarios could be:
- Improve admin UX by reducing block options for editors
- Prevent editors from using unsupported blocks
- Multiphase / retainer project where a subset of blocks are added / supported over time
- Restricting blocks to a particular user group, post type, or page template
- Using a custom block which replaces functionality of an existing block

Each project is different. Carefully consider removing blocks from the admin with your project team.

### Choosing to allow or deny access to blocks

Typically, you should exclude all blocks by default and add a list of which blocks to include versus including all blocks by default with a list of which to exclude. This helps guard against changes or blocks which are added at a later date, which could break functionality or have other unintented side effects. Blocks would have to be specifically allowed and tested before being used. Additionally, typical patterns for how we develop favor this in other locations (such as escaping, `<InnerBlocks>`, etc.) This helps keep a consistent pattern in the codebase.
