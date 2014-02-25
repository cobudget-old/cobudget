require 'active_record'

module Cobudget
  class User < ActiveRecord::Base
    before_create :generate_bg, :set_last_sign_in
    has_many :allocation_rights
    has_many :allocations
    has_many :accounts

    ADMIN_EMAILS = ['allansideas@gmail.com']

    def can_manage_accounts?
      if ADMIN_EMAILS.include? email 
        true
      else
        false
      end
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

    def set_last_sign_in
      self.last_sign_in_at = Time.now
    end
  end
end
