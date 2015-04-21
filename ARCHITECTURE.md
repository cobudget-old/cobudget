# Cobudget User Interface Architecture

So you want to learn about the architecture of Cobudget's User Interface? Sweet!

## Entry Points

There are three entry points that are bundled to the client:

1. [./src/index.js](./src/index.js)
1. [./src/index.html](./src/index.html)
1. [./src/index.sass](./src/index.sass)

## Modules

Everything is a module. The purpose of this is to isolate chunks of code that are not related (loose coupling) and group chunks of code that are related (tight cohesion). All the modules can found in [./src/node_modules](./src/node_modules).

Each module has a package.json which describes the entry point (the file that will be required on `require('module')`)

### Top-Level App

The top-level module is the [app module](./src/node_modules/app).

### Routes

### Models

### Stores

### Directives

### Modals


## Config

The configuration data for various environments is located in [./config](./config), which due to the [config module](./src/node_modules/config), is accessible in any other module using CommonJS modules as `require('config')` or using Angular modules as `config`.

## Build system

We use Gulp, see [./Gulpfile.coffee](./Gulpfile.coffee)

## Tests


