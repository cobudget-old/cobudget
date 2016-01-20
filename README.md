# Cobudget API

[![Build Status](https://travis-ci.org/cobudget/cobudget-api.svg?branch=master)](https://travis-ci.org/open-app/cobudget-api)
[![Code Climate](https://codeclimate.com/github/cobudget/cobudget-api/badges/gpa.svg)](https://codeclimate.com/github/cobudget/cobudget-api)

Cobudget is a web app helping people collaborate on budgets. For more about the project as a whole, check out the [top-level repo](https://github.com/cobudget/cobudget). This repo is the backend API of Cobudget.

**Don't push to master - feature branches and pull requests please.**

---

#### Install

```
git clone https://github.com/cobudget/cobudget-api
cd cobudget-api
bundle install

gem install mailcatcher
mailcatcher
```

#### Configure

To configure database environments, edit `config/database.yml`.

#### Setup

```
bundle exec rake db:setup
bundle exec rake db:seed
bundle exec rake jobs:work
```

#### Run

```
bundle exec rails s
```

#### Test

```
bundle exec rspec
```
