require 'active_record'

module Cobudget
  class Budget < ActiveRecord::Base
    has_many :buckets
    has_many :allocation_rights
  end
end