require 'playhouse/role'
#require 'cobudget/entities/allocation_right'
require 'money'

module Cobudget
  module BudgetParticipant
    include Playhouse::Role

    actor_dependency :allocation_rights

    SUM_COLUMN = :amount_cents

    def allocation_balance(budget)
      Money.new(base_scope(budget).sum(SUM_COLUMN))
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
