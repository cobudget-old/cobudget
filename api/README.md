# cobudget-api

[![Build Status](https://travis-ci.org/cobudget/cobudget-api.svg?branch=master)](https://travis-ci.org/cobudget/cobudget-api)
[![Code Climate](https://codeclimate.com/github/cobudget/cobudget-api/badges/gpa.svg)](https://codeclimate.com/github/cobudget/cobudget-api)

cobudget's backend api. for more information on the project as a whole, check out the [top-level repo](https://github.com/cobudget/cobudget)

**don't push to master - feature branches and pull requests please.**

---
## System setup/prerequisites

### set up heroku
add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"; 
curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -; apt-get update; apt-get install heroku

### system dependencies

```
apt-get update; apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs                                                                                                                                                                                          
apt-get install -y postgresql postgresql-server-dev-9.5
sudo -u postgres createuser <your username> -s
```

### get your ruby organized
```
git clone https://github.com/rbenv/ruby-build.git; cd ruby-build/; ./install.sh; ruby-build 2.4.2 /usr/local; ruby -v
gem install bundler
```

## Traditional development environment setup

### install
```
git clone https://github.com/cobudget/cobudget-api
cd cobudget-api
bundle install

gem install mailcatcher
```

### configure

`cp config/database.example.yml config/database.yml`.

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
cd /vagrant/api
bundle install
```

### Configure

`cp config/database.example.yml config/database.yml`

edit `config/database.yml`.

### Setup database

```
bundle exec rake db:setup
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
