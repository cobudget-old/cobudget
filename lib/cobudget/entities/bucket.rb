require 'active_record'
require 'support/money_attribute'

module Cobudget
  class Bucket < ActiveRecord::Base
    include MoneyAttribute
    money_attribute :minimum
    money_attribute :maximum
    belongs_to :sponsor, class_name: "User"

    belongs_to :budget

  end

end