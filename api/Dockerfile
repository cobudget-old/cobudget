FROM ruby:2.4.2
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs cron
WORKDIR /cobudget-api
COPY Gemfile* /cobudget-api/
RUN bundle install
COPY . /cobudget-api
COPY scripts/activity-emails /etc/cron.hourly
