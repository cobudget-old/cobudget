require 'active_record'
require 'support/money_attribute'
require 'cobudget/entities/account'
require 'cobudget/entities/user'
require 'cobudget/entities/entry'

module Cobudget
  class Transaction < ActiveRecord::Base
    #include MoneyAttribute
    #money_attribute :amount

    belongs_to :creator, class_name: 'User'
    has_many   :entries
  end
end
