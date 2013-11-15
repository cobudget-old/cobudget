#config.ru
require 'rubygems'
require 'sinatra'
require 'rack'

require 'cobudget_sinatra'
set :root, Pathname(__FILE__).dirname
set :environment, :staging
set :run, false
run CobudgetWeb