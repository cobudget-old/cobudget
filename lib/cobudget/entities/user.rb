require 'active_record'

module Cobudget
  class User < ActiveRecord::Base
    before_create :generate_bg
    has_many :allocation_rights
    has_many :allocations
    has_many :accounts

    def can_manage_accounts?
      true
    end

    def can_manage_buckets?
      true
    end

    def can_manage_budget?(budget)
      true
    end

    def budgets
      budget_ids = accounts.map(&:budget_id)
      #accounts.each do |acc|
        #budget_ids << acc.budget_id
      #end
      budgets = []
      budget_ids.each do |id|
        budgets << Budget.find(id)
      end
      budgets.as_json
    end

    def as_json(options={})
      super(
        methods: :budgets,
        include: { 
          accounts: {
            methods: :allocation_rights_cents
          }
        }
      )
    end

    def generate_bg
      self.bg_color = "#" + ("%06x" % (rand * 0xffffff))
    end
  end
end
