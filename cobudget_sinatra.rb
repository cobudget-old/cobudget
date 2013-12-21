$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
puts $LOAD_PATH
require 'sinatra/base'
require 'playhouse/sinatra'
require 'cobudget/cobudget_play'

class CobudgetWeb < Sinatra::Base
  register Playhouse::Sinatra
  set :root,  File.expand_path(File.join(File.dirname(__FILE__)))
  #before do
    #headers "Access-Control-Allow-Origin" => "*"
    #headers["Allow"] = "GET,POST,PUT,DELETE"
    #if request.request_method == 'OPTIONS'
      #headers "Access-Control-Allow-Origin" => "*", "Access-Control-Allow-Methods" => "POST, GET", "Access-Control-Allow-Headers" => "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, Origin"
      #status 200
    #end
  #end
  

  add_play Cobudget::CobudgetPlay

  run! if app_file == $0
end
