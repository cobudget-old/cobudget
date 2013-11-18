require 'active_record'

module Cobudget
  class Budget < ActiveRecord::Base
    has_many :buckets
  end
end