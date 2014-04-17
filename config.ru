$LOAD_PATH << '.'
#config.ru
require 'rubygems'
require 'json'
require 'sinatra'
require 'rack'
require 'rack/cors'
require 'config/airbrake'

use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '*',
        :methods => [:get, :post, :put, :patch, :delete, :options],
        :headers => :any,
        :max_age => 0
  end
end

use Rack::Session::Cookie, :key => 'cobudget',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'change_me'

require 'cobudget_web'
set :root, Pathname(__FILE__).dirname
set :environment, ENV['RACK_ENV']
set :run, false
run CobudgetWeb
