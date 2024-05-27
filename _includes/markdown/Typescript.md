The purpose of this document is to help guide Engineers in the usage of TypeScript at 10up projects. The goal here is not to teach TypeScript but rather explain the 10up stance on when to use TypeScript alongside general recommendations.

## Why TypeScript

We believe that:
1. TypeScript can make engineers more confident
2. TypeScript makes refactoring code easier
3. TypeScript helps engineers unfamiliar with the codebase

Therefore we are big fans of TypeScript at 10up and we strive to use it whenever it makes sense.

## When to use TypeScript

At 10up we require that all projects considered "JavaScript-First" to make use of TypeScript. Generally speaking Standard WordPress projects (including block development) would not fall under "JavaScript-First" projects. 

If you are building a project using Next.js and/or 10up's [HeadstartWP framework](https://headstartwp.10up.com/), Sanity and any other headless CMS'es powered by a React front-end then we require TypeScript unless other circumstances make using just JavaScript a better choice.

The main reason we don't require TypeScript for standard WordPress projects at the moment is that TypeScript support for block development is still very limited, largely driven by community types packages that don't always match the actual types for the `@wordpress` packages.

## How to use TypeScript

In an ideal world, every engineer would be fully capable of writing all sorts of complex TypeScript types, however, we understand that it takes time to master a language like TypeScript, especially in a few scenarios that require writing more complex types. Therefore, while we use a reasonably strict `tsconfig.json`` we are flexible in practice. 

We want the TypeScript to always be valid and issue no errors at compilation, but we allow a few escape hatches should engineers get stuck with a particular typing problem. We follow the principles below when writing TypeScript:

### 1. Never ship code that has compilation issues

Depending on the tooling you're using (e.g. Next.js) it is possible to disable type checking and still compile invalid TS code as long as the underlying JS code is valid. While the runtime behavior might still be working as expected this is not a recommended practice and generally would just make engineers not have trust in the type system. If you are facing a challenge typing something it is better to use some of the escape hatches documented below instead of just ignoring TS errors.

### 2. Favor efficiency instead of strict typing
In an ideal world, all engineers would be capable of typing everything properly from the get-go. However, we know that is not the case and engineers need time and practice to get there. For that reason, we favor efficiency over strict typing. 

Our philosophy is that over time engineers will organically get more familiar with TypeScript and strictness will come as a result. Code reviews are also a place where engineers might get quick feedback that would allow them to more efficiently address typing issues instead of wasting a lot of time during initial development trying to figure it out on their own.

When facing such typing challenges we recommend the following strategies as an escape hatch:
#### 1. The `as unknown as ExpectedType` type cast

When struggling with a type that does not match the expected type, one of the escape hatches we recommend is to forcibly typecast the type to the expected type:

```ts
// force the variable to have the type `ExpectedType`
const withExpectedType = myValueThatWithWrongType as unknown as ExpectedType;
```

While this usually indicates that there's something wrong with types or even the code itself, this would at least provide type checking for the subsequent lines of code. This strategy, for instance, is much better than just typing as any.

#### 2. The `any` type.

Another strategy is to just type your variable with `any` which essentially disables type checking for that variable and while it is a more drastic measure it should be an easy way to unblock work until engineers have more time to come back and try to get the types right.

Note: we recommend setting the `noImplicitAny` setting to `true` in `tsconfig.json` which forces explicitly setting a type as any. This makes it easier to identify code that is relying on any and would also make catching the escape hatch in code reviews which is a great opportunity to get feedback and potentially get the types right.

#### 3. The `// @ts-expect-error` comment

Lastly, if nothing else worked to unblock the code, TypeScript allows disregarding errors on a given line by just telling the compiler that an error is expected on that line. This is usually the least effective option as it would only solve the problem for a single line. However, if nothing else works, this is the last and most drastic escape hatch.

While we'd like none of these escape hatches to be used, it would be unrealistic to expect all engineers to have types 100% correct on every project all the time. We believe that these recommendations provide a path to address them organically during the life-cycle of the project.

## TypeScript and CI

We recommend that all projects run the typescript compiler to check type safety at the CI level. Every Pull Request/Merge Request should run `tsc --noEmit` on CI to ensure there are no compilation issues before merging the branch.

This is a great strategy to avoid builds failing due to type errors. With Next.js for instance, you might not realize you have a TS compilation issue until a build is executed, therefore to avoid merging code that produces failing builds we recommend always ensuring that the code has no TypeScript compilation issues before merging.

## Recommended `tsconfig.json` settings

This is not a full list but we highlight some recommended settings here.

1. `noFallthroughCasesInSwitch: true`- [Definition](https://www.typescriptlang.org/tsconfig/#noFallthroughCasesInSwitch) - ensures you are not skipping anything in a switch statement, and always at least provide a default option.
2. `noImplicitAny: true` - [Definition](https://www.typescriptlang.org/tsconfig/#noImplicitAny) - ensures you define `any` explicitly, rather than implicitly assume it. This makes it a lot easier to find all code relying on any for future refactoring.
3. `strictNullChecks: true` - [Definition](https://www.typescriptlang.org/tsconfig/#strictNullChecks) - forces handling both `undefined` and `null`
4. `noUnusedParameters: true` - [Definition](https://www.typescriptlang.org/tsconfig/#noUnusedParameters) - does not allow unused parameters to remain in code

## TypeScript and React

### Use `type` for React Props

While `interface` and `type` are mostly interchangeable, prefer `type` over `interfaces` unless you expect the props to be the base for other components's props.

```ts
type BlocksProps = {
	html: string;
};

export const Blocks = ({ html }: BlocksProps) => {
    // render blocks
}
```

### Use function default arguments instead of `defaultProps`

`defaultProps` has been deprecated in React 19, therefore prefer using function default arguments.

```ts
type MyComponentProps = {
    title?: strinmg;
};

export const MyComponent = ({ title = 'Default Title' }: MyComponentsProps) => {
    // ...
}
```

Make sure the eslint rule `react/require-default-props` is set up to look for `defaultArguments` e.g `'react/require-default-props': ['error', { functions: 'defaultArguments' }]`;

### Prefer explicitly declaring `children` instead of using `PropsWithChildren`

`PropsWithChildren` will make `children` optional, but sometimes you do want to be very explicit and make it required. Therefore we generally recommend declaring `children` explicitly.

```ts
type LayoutProps = {
    children: React.Node
};

// Layout has passed a children prop
const Layout = (props: LayoutProps) {
    return (
        <main>
            {children}
        </main>
    );
}
```

### Avoid prop spreading

Prop spreading is when you simply forward all props to another component e.g:

```ts
// AVOID DOING THIS
const PostProps = {
    title: string,
    category: string,
    link: string
    // other props
};

const Post = (props: PostProps) => {
    return (
        <article>
            <PostContent {...props}>
        </article>
    );
}
```

While there might be use cases where you need to use them, it's generally better to avoid them and pass props explicitly. In the example above it would be better to just pass a `post` object as a single prop.

Prop spreading is especially dangerous when prop spreading into native DOM elements. So make sure to not ignore TypeScript errors and make sure your types are set up correctly so that TS can catch forwarded props incompatible with the target component/element.

### Colocate types with React components

For the most part, the React Component types should be colocated with the React component, meaning that it should be in the same file that the React component is written. Only hoist types to avoid circular dependencies and when you expect them to be reused/shared across many components/files.

### Use `@types` packages if necessary

If the library you're using does not ship types, check if there is type information available for that package in the [DefinatelyTyped](https://github.com/DefinitelyTyped/DefinitelyTyped) repo.

### Global types definitions

**Do not** put the application types in the global scope just to avoid importing them. You may only create global type definitions when needing to extend global types (e.g `window` object).

To extend global types create a `global.d.ts` file and include them in your `tsconfig.json` in the `include` config option. Here's an example for a Next.js project:

```json
 "include": [
    "next-env.d.ts",
    "src/global.d.ts",
    "**/*.ts",
    "**/*.tsx"
  ],
```

```ts
// globals.d.ts
interface Window {
    // add any methods or props added by third party scripts/libraries
    custom_prop: number;
}
```
