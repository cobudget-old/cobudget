require 'playhouse/role'
require 'money'

module Cobudget
  module BudgetParticipant
    include Playhouse::Role

    actor_dependency :id
    actor_dependency :allocation_rights

    SUM_COLUMN = :amount_cents

    def allocation_rights_total(budget)
      Money.new(base_scope(budget).map(&:amount).sum)
    end

    def has_allocation_rights?(budget)
      !base_scope(budget).blank?
    end

    def get_allocation_rights(budget)
      Money.new(base_scope(budget).map(&:amount).sum)
    end

    private

    def base_scope(budget)
      allocation_rights.where(budget: budget)
    end
  end
end
