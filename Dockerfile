FROM ruby:2.4.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /cobudget
WORKDIR /cobudget
COPY Gemfile /cobudget/Gemfile
COPY Gemfile.lock /cobudget/Gemfile.lock
RUN bundle install
COPY . /cobudget