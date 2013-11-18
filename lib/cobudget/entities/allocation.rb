require 'active_record'
require 'support/money_attribute'

module Cobudget
  class Allocation < ActiveRecord::Base
    include MoneyAttribute
    money_attribute :amount
    belongs_to :user
    belongs_to :bucket
  end

end
