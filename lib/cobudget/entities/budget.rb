require 'active_record'

module Cobudget
  class Budget < ActiveRecord::Base
    has_many :buckets
    has_many :allocations
    has_many :accounts
  end
end
