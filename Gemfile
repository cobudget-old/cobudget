source 'https://rubygems.org'

gem 'rails', '~> 4.2.3'
gem 'rails-api'
gem 'spring', :group => :development

# persistance
gem 'pg'
gem 'foreigner'

# api
gem 'apipie-rails'
gem 'active_model_serializers', '~> 0.8.0'
gem 'activesupport-json_encoder'
gem 'rack-cors', :require => 'rack/cors'
gem 'responders', '~> 2.0'

# model utilities
gem 'money-rails'

# auth
gem 'devise', '~> 3.5.2'
gem 'pundit'
gem 'devise_token_auth', '~> 0.1.37'
gem 'omniauth'

# server
gem 'puma'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'sinatra', :require => nil

# error tracking
gem 'airbrake'

# using faker and factory girl to generate fake users for staging app, will put back in group :development, :test when in production
gem 'faker'
gem 'factory_girl_rails'

gem 'redcarpet'

group :development do
  gem 'capistrano', '2.15.5'
  gem "capistrano-rails", '~> 1.0.0'
  gem "rails-erd"
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'database_cleaner'
  gem 'simplecov', :require => false
  gem 'timecop'
end

group :production do
  gem 'rails_12factor'
  gem 'delayed-plugins-airbrake'
end

ruby "2.2.1"
