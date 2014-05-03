$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'yaml'
require 'logger'
require 'sinatra/base'
require 'playhouse/sinatra'
require 'cobudget/cobudget_play'

class CobudgetWeb < Sinatra::Base
  use Airbrake::Rack
  enable :raise_errors

  register Playhouse::Sinatra
  set :root,  File.expand_path(File.join(File.dirname(__FILE__)))
  set :protection, :except => [:http_origin]
  routes = YAML.load_file('config/routes.yml')

  configure do
    $logger = Logger.new("#{settings.root}/log/#{settings.environment}.log", 'monthly')
    use Rack::CommonLogger, $logger
  end

  theatre = Cobudget::CobudgetTheatre.new(root: settings.root, environment: settings.environment)
  add_play theatre, Cobudget::CobudgetPlay, routes

  run! if app_file == $0
end
