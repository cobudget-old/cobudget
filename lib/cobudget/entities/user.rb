require 'active_record'

module Cobudget
  class User < ActiveRecord::Base
    has_many :allocation_rights
  end
end