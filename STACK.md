# Cobudget User Interface Stack

So you want to learn about the internals of Cobudget's user interface? Sweet!

## Entry Points

There are three entry points that are bundled to the client:

1. [./src/index.js](./src/index.js): this is the entry point for [`browserify`](http://browserify.org) which traverses, transforms, and bundles our Javascript into a single `build/scripts/index.js`.
1. [./src/index.sass](./src/index.sass): this is the entry point for [`sass`](http://sass-lang.com) which traverses, transforms, and bundles our Sass into a single `build/styles/index.css`.
1. [./src/index.html](./src/index.html): this is the file delivered to the client on page fetch, which references the above JS and CSS bundles.

## Modules

Everything is a module. The purpose of this is to isolate chunks of code that are not related (loose coupling) and group chunks of code that are related (tight cohesion). All the modules can found in [./src/node_modules](./src/node_modules). All the code related to a module (Javascript, Sass styling, Html templates, etc) should be in that module's directory.

Each module is a proper [Node module](https://github.com/substack/browserify-handbook#node-packaged-modules) with a package.json which describes the entry point (the file that will be required on `require('module')`) and any [browserify transforms](https://github.com/substack/browserify-handbook#browserifytransform-field) that should be applied.

### Top-Level App

The top-level module is the [app module](./src/node_modules/app). This module registers all the Node modules with Angular's own module format (which means most modules load each other through [Angular's Dependency Injection system](https://docs.angularjs.org/guide/di)) as well as performs any high-level configuration. An important set of configurations are the [ui-router](https://github.com/angular-ui/ui-router) [routes](./src/node_modules/app/routes.coffee), which determine the nested page hierarchy.

### Routes

Each route module, which combines a match url, template, controller, and styles, exports the [format expected by ui-router's `$stateProvider.state` function](https://github.com/angular-ui/ui-router/wiki). In order to handle nested views, including a top-level layout, some routes are `abstract` routes which are not navigated to but provide a shell for child views.

### Models

Each model module, which describes an instance of a type of data, exports a extension of [`ampersand-state`](https://github.com/AmpersandJS/ampersand-state/), typically starting with [`base-model`](./src/node_modules/base-model).

### Stores

Each store module, which describes how to interact with the [Cobudget API](https://github.com/cobudget/cobudget-api) for a type of data, exports a singleton which extends [`restful-store`](./src/node_modules/restful-store).

### Directives

Each directive module exports the format expected of an [Angular directive](https://docs.angularjs.org/guide/directive).

### Modals

Each modal module exports the format expected of an [Angular Bootstrap modal](https://angular-ui.github.io/bootstrap/#/modal).

## Config

The configuration data for various environments is located in [./config](./config), which due to the [config module](./src/node_modules/config), is accessible in any other module using CommonJS modules as `require('config')` or using Angular modules as `config`.

## Task Runner / Build System

We use Gulp, see [./Gulpfile.coffee](./Gulpfile.coffee) for more info.

## Tests

We use Protractor and Testling-style tests, see [README](./README.md) for how to run.
