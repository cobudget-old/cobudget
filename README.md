# Cobudget! backend interface

[![Code Climate](https://codeclimate.com/github/enspiral/cobudget-api.png)](https://codeclimate.com/github/enspiral/cobudget-api)
[![Build Status](https://travis-ci.org/enspiral/cobudget-api.png)](https://travis-ci.org/enspiral/cobudget-api)

Cobudget is a web app helping people collaborate on budgets. For more about the project as a whole, check out the [top-level repo](https://github.com/open-app/cobudget). This repo is the backend interface component.

#### Don't push to master - feature branches and pull requests please.

## How to...

### Install

Install ruby and gem: https://www.ruby-lang.org/en/installation/

```
git clone https://github.com/open-app/cobudget-api
cd cobudget-api
bundle install
```

### Configure

To configure database environments, edit `config/database.yml`.

### Setup database

*Setup and seed the db:*

```
bundle exec rake db:setup
```

*Create the db:*

```
bundle exec rake db:create
```

*Migrate the db:*

````
bundle exec rake db:migrate
```

*Drop the db*

```
bundle exec rake db:drop
```

### Run

*Start server:*

```
bundle exec rails s
```

### Test

*Test*

```
bundle exec rake spec
```
