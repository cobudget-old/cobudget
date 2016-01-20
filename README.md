# cobudget-api

[![Build Status](https://travis-ci.org/cobudget/cobudget-api.svg?branch=master)](https://travis-ci.org/open-app/cobudget-api)
[![Code Climate](https://codeclimate.com/github/cobudget/cobudget-api/badges/gpa.svg)](https://codeclimate.com/github/cobudget/cobudget-api)

cobudget's backend api. for more information on the project as a whole, check out the [top-level repo](https://github.com/cobudget/cobudget)

**don't push to master - feature branches and pull requests please.**

---

### install

```
git clone https://github.com/cobudget/cobudget-api
cd cobudget-api
bundle install

gem install mailcatcher
mailcatcher
```

### configure

edit `config/database.yml`.

### setup

```
bundle exec rake db:setup
bundle exec rake db:seed
bundle exec rake jobs:work
```

### run

```
bundle exec rails s
```

### test

```
bundle exec rspec
```
