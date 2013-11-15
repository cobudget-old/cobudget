require 'active_record'
require 'support/money_attribute'
require 'cobudget/entities/budget'

module Cobudget
  class Bucket < ActiveRecord::Base
    include MoneyAttribute
    #money_attribute :minimum
    #money_attribute :maximum
    #has_one :sponsor, class: User

    belongs_to :budget

  end

end