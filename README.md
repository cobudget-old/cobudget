# Cobudget API

[![Build Status](https://travis-ci.org/cobudget/cobudget-api.svg?branch=master)](https://travis-ci.org/open-app/cobudget-api)
[![Code Climate](https://codeclimate.com/github/cobudget/cobudget-api/badges/gpa.svg)](https://codeclimate.com/github/cobudget/cobudget-api)

Cobudget is a web app helping people collaborate on budgets. For more about the project as a whole, check out the [top-level repo](https://github.com/open-app/cobudget). This repo is the backend API of Cobudget.

#### Don't push to master - feature branches and pull requests please.

## How to...

### Install

Install ruby and gem: https://www.ruby-lang.org/en/installation/

```
git clone https://github.com/open-app/cobudget-api
cd cobudget-api
bundle install
```

Install [MailCatcher](http://mailcatcher.me/)

```
gem install mailcatcher
mailcatcher
```

and visit: http://localhost:1080/

### Configure

To configure database environments, edit `config/database.yml`.

### Setup database

*Setup and seed the db:*

```
bundle exec rake db:setup
```

### Run

*Start rails server:*

```
bundle exec rails s
```

*Start Workers*

```
rake jobs:work
```

### Test

*Test*

```
bundle exec rspec
```
