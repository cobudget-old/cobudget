require 'active_record'

module Cobudget
  class User < ActiveRecord::Base
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

    def as_json(options={})
      super(
        include: { 
          accounts: {
            methods: :allocation_rights_cents
          }
        }
      )
    end
  end
end
