require 'active_record'
require 'cobudget/entities/account'
require 'cobudget/entities/transaction'
require 'support/money_attribute'

module Cobudget
  class Entry < ActiveRecord::Base
    include MoneyAttribute
    money_attribute :amount

    belongs_to :account, polymorphic: true
    belongs_to :transaction
  end
end
