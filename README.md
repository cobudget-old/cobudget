[![Stories in Ready](https://badge.waffle.io/open-app/cobudget-ui.png?label=ready&title=Ready)](https://waffle.io/open-app/cobudget-ui)
# Cobudget! user interface

[![Build Status](https://travis-ci.org/open-app/cobudget-ui.svg?branch=master)](https://travis-ci.org/open-app/cobudget-ui)
[![Code Climate](https://codeclimate.com/github/open-app/cobudget-ui/badges/gpa.svg)](https://codeclimate.com/github/open-app/cobudget-ui)

Cobudget is a web app helping people collaborate on budgets. For more about the project as a whole, check out the [top-level repo](https://github.com/open-app/cobudget). This repo is the user interface component.

[Trello Board](https://trello.com/b/LsbPRkRl/cobudget-dev) | [Style Guide](https://github.com/toddmotto/angularjs-styleguide)

#### Don't push to master - feature branches and pull requests please.

## How to...

### Install

Install node and npm: https://github.com/joyent/node/wiki/Installation 

```
git clone https://github.com/open-app/cobudget-ui
cd cobudget-ui
npm install
```

### Run

*Watch and start livereload server:*

```
npm run develop
```

*Build and start static server:*

```
npm start
```

*Test*

```
npm test
```

*Stage (push to gh-pages)*

```
NODE_ENV=production npm run stage
```

*Deploy (push to dokku)*

```
git remote add deploy dokku@next.cobudget.co:app
```

```
NODE_ENV=production npm run deploy
```

### Configure

To configure `production` and other environments, copy `config/development.coffee` to `config/production.coffee` and change properties as appropriate. If you need to access other environment variables, use `process.env.VAR_NAME`, as the config is simply coffeescript.
