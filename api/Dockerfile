FROM ruby:2.4.2
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs cron && \
    rm -rf /var/lib/apt/lists/*
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /wait-for-it.sh
WORKDIR /cobudget-api
COPY Gemfile* /cobudget-api/
RUN bundle install && \
    gem install mailcatcher && \
    chmod +x /wait-for-it.sh
COPY . /cobudget-api
COPY scripts/activity-emails /etc/cron.hourly

