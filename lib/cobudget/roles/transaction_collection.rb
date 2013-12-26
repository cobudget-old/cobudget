require 'playhouse/role'
require 'cobudget/entities/transfer'
require 'money'

module Cobudget
  module TransactionCollection
    include Playhouse::Role

    SUM_COLUMN = :amount_cents

    actor_dependency :id
    actor_dependency :transactions

    def balance
      Money.new(base_scope.sum(SUM_COLUMN))
    end

    def has_no_allocations?
      transactions.count == 0
    end

    def is_empty?
      balance == 0
    end

    private

    def base_scope
      transactions
    end
  end
end