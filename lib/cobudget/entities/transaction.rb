require 'active_record'
require 'cobudget/entities/account'
require 'cobudget/entities/transfer'
require 'support/money_attribute'

module Cobudget
  class Transaction < ActiveRecord::Base
    include MoneyAttribute
    money_attribute :amount

    belongs_to :account, polymorphic: true
    belongs_to :transfer

    scope :involving_user_account, ->(user_account) { where account: user_account, account_type: 'Account' }
    scope :involving_bucket, ->(bucket) { where account: bucket, account_type: 'Bucket' }
  end
end