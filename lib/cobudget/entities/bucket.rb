require 'active_record'
require 'support/money_attribute'

module Cobudget
  class Bucket < ActiveRecord::Base
    include MoneyAttribute
    money_attribute :minimum
    money_attribute :maximum

    belongs_to :sponsor, class_name: "User"

    belongs_to :budget
    has_many :entries, as: :account

    #self.connection - same as ActiveRecord::Base.connection but can point to a different data provider
    def sponsor_name_or_email
      if sponsor
        sponsor.name.blank? ? sponsor.email : sponsor.name
      else
        "N/A"
      end
    end

    def as_json(options={})
      super(
        methods: :sponsor_name_or_email 
      )
    end
  end

end
