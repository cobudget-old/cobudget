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

  configure do
    enable :logging
    @log_file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
    @log_file.sync = true
  end

  configure :development do
    use Rack::CommonLogger, @log_file
  end

  configure :staging do
    set :logging, Logger::DEBUG
    STDOUT.reopen(@log_file)
    STDERR.reopen(@log_file)

    STDOUT.sync = true
    STDERR.sync = true
  end

  before do
    $logger = logger
  end


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
