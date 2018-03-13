FROM ruby:2.4.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /cobudget-api
WORKDIR /cobudget-api
COPY api/Gemfile /cobudget-api/Gemfile
COPY api/Gemfile.lock /cobudget-api/Gemfile.lock
RUN bundle install
RUN gem install mailcatcher
COPY api /cobudget-api