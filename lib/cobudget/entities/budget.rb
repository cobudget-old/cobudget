require 'active_record'
require 'cobudget/entities/bucket'

module Cobudget
  class Budget < ActiveRecord::Base
    has_many :buckets
  end
end