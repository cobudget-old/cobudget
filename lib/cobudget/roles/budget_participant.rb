require 'playhouse/role'
require 'money'

module Cobudget
  module BudgetParticipant
    include Playhouse::Role

    actor_dependency :id
    actor_dependency :allocation_rights

    SUM_COLUMN = :amount_cents

    def allocation_rights_total(budget)
      right = base_scope(budget)
      if right.nil?
        0
      else
        Money.new(right.amount)
      end
    end

    def has_allocation_rights?(budget)
      base_scope(budget).nil? || base_scope(budget).amount == 0
    end

    def get_allocation_rights(budget)
      base_scope(budget).amount unless base_scope(budget).nil?
    end

    private

    def base_scope(budget)
      allocation_rights.where(budget: budget).first
    end
  end
end
