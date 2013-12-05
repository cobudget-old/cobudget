require 'playhouse/role'
require 'cobudget/entities/transfer'
require 'money'

module Cobudget
  module AccountHolder
    include Playhouse::Role

    actor_dependency :id
    actor_dependency :accounts

    SUM_COLUMN = :amount_cents

    def balance
      Money.new(base_scope.sum(SUM_COLUMN))
    end

    def balance_in_budget(budget)
      Money.new(base_scope.where(budget: budget).sum(SUM_COLUMN))
    end

    private

    def base_scope
      accounts
    end
  end
end
