$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'yaml'
require 'sinatra/base'
require 'playhouse/sinatra'
require 'cobudget/cobudget_play'

class CobudgetWeb < Sinatra::Base
  register Playhouse::Sinatra
  set :root,  File.expand_path(File.join(File.dirname(__FILE__)))
  routes = YAML.load_file('config/routes.yml')

  add_play Cobudget::CobudgetPlay, routes

  run! if app_file == $0
end
