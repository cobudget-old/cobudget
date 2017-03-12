source 'https://rubygems.org'

gem 'rails'
gem 'rails-api'
gem 'spring', :group => :development

# payments
gem 'stripe'

# persistance
gem 'pg'
gem 'foreigner'

# api
gem 'apipie-rails'
gem 'active_model_serializers', '~> 0.8.0'
gem 'activesupport-json_encoder'
gem 'rack-cors', :require => 'rack/cors'
gem 'responders'

# model utilities
gem 'money-rails'
gem 'groupdate'

# auth
gem 'devise'
gem 'pundit'
gem 'devise_token_auth'
gem 'omniauth'

# server
gem 'puma'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'sinatra', :require => nil

# error tracking
gem 'airbrake'

gem 'newrelic_rpm'

gem 'redcarpet'

group :development do
  gem 'capistrano', '2.15.5'
  gem "capistrano-rails", '~> 1.0.0'
  gem "rails-erd"
end

group :development, :test do
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'database_cleaner'
  gem 'simplecov', :require => false
  gem 'timecop'
  gem 'faker'
  gem 'factory_girl_rails'
end

group :production do
  gem 'rails_12factor'
  gem 'delayed-plugins-airbrake'
end

ruby "2.4.0"
