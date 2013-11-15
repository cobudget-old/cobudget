$LOAD_PATH << '.'
#config.ru
require 'rubygems'
require 'sinatra'
require 'rack'

require 'cobudget_sinatra'
set :root, Pathname(__FILE__).dirname
set :environment, ENV['RACK_ENV']
set :run, false
run CobudgetWeb
