# cobudget-api

[![Build Status](https://travis-ci.org/cobudget/cobudget-api.svg?branch=master)](https://travis-ci.org/cobudget/cobudget-api)
[![Code Climate](https://codeclimate.com/github/cobudget/cobudget-api/badges/gpa.svg)](https://codeclimate.com/github/cobudget/cobudget-api)

cobudget's backend api. for more information on the project as a whole, check out the [top-level repo](https://github.com/cobudget/cobudget)

**don't push to master - feature branches and pull requests please.**

---

## Traditional development environment setup

### install

```
git clone https://github.com/cobudget/cobudget-api
cd cobudget-api
bundle install

gem install mailcatcher
```

### configure

edit `config/database.yml`.

### setup

```
bundle exec rake db:setup
bundle exec rake jobs:work
```

### run

Start the mailcatcher, start the server that handles delayed mail delivery and start the webserver

```
mailcatcher
bin/delayed_job start
bundle exec rails s
```

The mail can be inspected at localhost:1080

### test

```
bundle exec rspec
```

## Development environement setup using Vagrant

### Preconditions
* Install [Vagrant](https://www.vagrantup.com)
* Install [VirtualBox](https://www.virtualbox.org)

### Install

First, clone the repo from git. Then

```
cd cobudget-api
vagrant up
vagrant ssh
cd /vagrant
bundle install
```

### Configure

`cp config/database.example.yml config/database.yml`

edit `config/database.yml`.

### Setup database

```
bundle exec rake db:setup`
```

### Run tests

```
bundle exec rspec
```

### Run the server

Start the mailcatcher, start the server that handles delayed mail delivery and start the webserver

```
mailcatcher
bin/delayed_job start
bundle exec rails s
```

The mail can be inspected at localhost:1080
