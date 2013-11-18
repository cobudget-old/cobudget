require 'active_record'

module Cobudget
  class User < ActiveRecord::Base
    has_many :allocation_rights
    has_many :allocations
  end
end