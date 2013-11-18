require 'active_record'
require 'support/money_attribute'

module Cobudget
  class AllocationRight < ActiveRecord::Base
    include MoneyAttribute
    money_attribute :amount
    belongs_to :user
    belongs_to :budget
  end

end