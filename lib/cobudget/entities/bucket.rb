require 'active_record'
require 'state_machine'
require 'support/money_attribute'

module Cobudget
  class Bucket < ActiveRecord::Base
    include MoneyAttribute
    money_attribute :minimum
    money_attribute :maximum

    belongs_to :sponsor, class_name: "User"

    belongs_to :budget
    has_many :entries, as: :account

    state_machine initial: :open do
      event :set_funded do
        transition :open => :funded
      end

      event :set_cancelled do
        transition :open => :cancelled
      end

      before_transition :open => :funded do |bucket|
        bucket.funded_at = Time.now
      end

      before_transition :open => :cancelled do |bucket|
        bucket.cancelled_at = Time.now
      end
    end

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
