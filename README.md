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

### Configure

To get up and running copy `config/environments/sample.json` to `config/environments/development.json` remove the comments, and add your custom settings.  At the moment you will also need to copy to `config/environments/staging.json`, and `config/environments/development.json`.

Likewise you will need to setup production.json and staging.json for deploying to work.

### Run

*Start the server:*

```
npm start
```

*Testing*

TODO: how to install webdriver-manager

```
webdriver-manager start
npm test
```

*Deploying*

```
npm run deploy
```
