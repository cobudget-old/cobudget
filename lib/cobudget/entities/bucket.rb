require 'active_record'
require 'support/money_attribute'

module Cobudget
  class Bucket < ActiveRecord::Base
    include MoneyAttribute
    money_attribute :minimum
    money_attribute :maximum

    belongs_to :sponsor, class_name: "User"
    has_many :accounts, as: :owner

    belongs_to :budget
    has_many :allocations
  end

end