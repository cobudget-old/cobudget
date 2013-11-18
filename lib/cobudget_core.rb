require 'active_record'
require 'sqlite3'
require 'active_record/connection_adapters/sqlite3_adapter'
require 'cobudget/api'
require 'pusher'

module Cobudget
  ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  Pusher.key = '6ea7addcc0137ddf6cf0'
  Pusher.secret = '882cd62d5475bc7edee3'
  Pusher.app_id = '59272'
end