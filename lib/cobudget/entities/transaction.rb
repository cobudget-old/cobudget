require 'active_record'
require 'cobudget/entities/account'
require 'cobudget/entities/transfer'
require 'support/money_attribute'

module Cobudget
  class Transaction < ActiveRecord::Base
    include MoneyAttribute
    money_attribute :amount

    belongs_to :account
    belongs_to :transfer
  end
end