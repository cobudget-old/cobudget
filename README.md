[![Stories in Ready](https://badge.waffle.io/open-app/cobudget-ui.png?label=ready&title=Ready)](https://waffle.io/open-app/cobudget-ui)
# Cobudget! user interface

[![Build Status](https://travis-ci.org/open-app/cobudget-ui.svg?branch=master)](https://travis-ci.org/open-app/cobudget-ui)
[![Code Climate](https://codeclimate.com/github/open-app/cobudget-ui/badges/gpa.svg)](https://codeclimate.com/github/open-app/cobudget-ui)

Cobudget is a web app helping people collaborate on budgets. For more about the project as a whole, check out the [top-level repo](https://github.com/open-app/cobudget). This repo is the user interface component.

## [CONTRIBUTING](./CONTRIBUTING.md)

## [STACK](./STACK.md)

## How to...

### Install

Install node and npm: https://github.com/joyent/node/wiki/Installation 

```
git clone https://github.com/cobudget/cobudget-ui
cd cobudget-ui
npm install
```

### Configure

To configure `production` and other environments, copy `config/development.coffee` to `config/production.coffee` and change properties as appropriate. If you need to access other environment variables, use `process.env.VAR_NAME`, as the config is simply coffeescript.

### Run

*Build on watch and start livereload server:*

```
npm run develop
```

*Build once and start static server:*

```
npm start
```

### Deploy

*Stage (push to this repo's gh-pages)*

```
NODE_ENV=production npm run stage
```

*Deploy (push to prod repo's gh-pages)*

```
npm run set-remote
```

```
npm run deploy
```

### Test

To setup e2e (integration) tests, in another terminal run `npm run webdriver-update` to install Selenium and `npm run webdriver-start` to start the Selenium serer. The UI server must be running (`npm run develop` or `npm start`)while performing e2e tests.

*Run all tests*

```
npm test
```

*Run only spec tests*

```
npm run test-spec
```

*Run only e2e tests*

```
npm run test-e2e
```

# beta.cobudget.co
production deploy of Cobudget beta
