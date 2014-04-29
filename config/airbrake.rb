require 'airbrake'

Airbrake.configure do |config|
  config.api_key = '51bfbc400d5b088a041e2dca38c639b9'
  config.environment_name = ENV['ENV'] || 'development'
end
