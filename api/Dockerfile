FROM ruby:2.4.2
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs cron
WORKDIR /cobudget-api
COPY Gemfile* /cobudget-api/
RUN gem install bundler -v 1.17.3 && bundle install
COPY . /cobudget-api
COPY scripts/activity-emails /etc/cron.hourly
