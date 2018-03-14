FROM ruby:2.4.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /cobudget-api
WORKDIR /cobudget-api
COPY Gemfile /cobudget-api/Gemfile
COPY Gemfile.lock /cobudget-api/Gemfile.lock
RUN bundle install
RUN gem install mailcatcher
COPY . /cobudget-api