$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'sinatra/base'
require 'playhouse/sinatra'
require 'cobudget/api'

class CobudgetWeb < Sinatra::Base
  register Playhouse::Sinatra
  #set :root,  File.expand_path(File.join(File.dirname(__FILE__)))
  before do
    headers 'Access-Control-Allow-Origin' => '*'
  end

  add_play Cobudget::API

  run! if app_file == $0
end
