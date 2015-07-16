source 'https://rubygems.org'

gem 'rails', '~> 4.2.3'

gem 'rails-api'

gem 'spring', :group => :development

# persistance

gem 'pg'
gem 'foreigner'

# api

gem 'apipie-rails'
gem 'active_model_serializers', '~> 0.9.0'
gem 'rack-cors', :require => 'rack/cors'
gem 'responders', '~> 2.0'

# model utilities

gem 'money-rails'

# auth

gem "devise"
gem 'pundit'

# server

gem 'puma'

gem 'delayed_job_active_record'
gem 'daemons'

gem 'sinatra', :require => nil

# error tracking
gem 'airbrake'

group :development do
  gem 'capistrano', '2.15.5'
  gem "capistrano-rails", '~> 1.0.0'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'simplecov', :require => false
  gem 'shoulda-matchers'
end

group :production do
  gem 'rails_12factor'
end

ruby "2.2.1"