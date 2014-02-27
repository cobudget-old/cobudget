$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'yaml'
require 'sinatra/base'
require 'playhouse/sinatra'
require 'cobudget/cobudget_play'
require 'cobudget/production'
require 'cobudget_theatre'

class CobudgetWeb < Sinatra::Base
  #production = Cobudget::Production.new
  #theatre = Cobudget::CobudgetTheatre.new(root: settings.root, environment: settings.environment)

  #production.run theatre: theatre, interface: Playhouse::Sinatra::Interface, interface_args: ARGV

  register Playhouse::Sinatra
  set :root,  File.expand_path(File.join(File.dirname(__FILE__)))
  #disable :protection
  set :protection, :except => [:http_origin]
  routes = YAML.load_file('config/routes.yml')

  production = Cobudget::Production.new
  production.routes = routes
  theatre = Cobudget::CobudgetTheatre.new(root: settings.root, environment: settings.environment)
  #root: settings.root, environment: settings.environment

  add_play theatre, Cobudget::CobudgetPlay, routes

  #production.run(theatre: theatre, interface: nil, interface_args: ARGV )

  run! if app_file == $0

  def build_cobudget_web theatre

  end
end
