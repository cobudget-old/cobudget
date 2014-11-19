source 'https://rubygems.org'

gem 'rails', '4.1.5'

gem 'rails-api'

gem 'spring', :group => :development


# persistance

gem 'pg'
gem 'foreigner'

# api

gem 'apipie-rails'
gem 'active_model_serializers', '~> 0.9.0'
gem 'inherited_resources'
gem 'rack-cors', :require => 'rack/cors'

# model utilities

gem 'money-rails'

# auth

gem "devise"

group :development do
  gem 'capistrano', '2.15.5'
  gem "capistrano-rails", '~> 1.0.0'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'faker'
  gem 'pry-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

gem 'rails_12factor', group: :production
