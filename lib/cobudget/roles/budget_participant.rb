require 'playhouse/role'
require 'money'

module Cobudget
  module BudgetParticipant
    include Playhouse::Role

    actor_dependency :id
    actor_dependency :accounts

    SUM_COLUMN = :amount_cents

    def allocation_rights_total(budget)
      Money.new(base_scope(budget).map(&:balance).sum)
    end

    def has_allocation_rights?(budget)
      !base_scope(budget).blank?
    end

    def get_allocation_rights(budget)
      base_scope(budget)
    end

    private

    def base_scope(budget)
      accounts.where(budget: budget)
    end
  end
end
