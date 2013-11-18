require 'playhouse/role'
require 'cobudget/entities/allocation'
require 'money'

module Cobudget
  module AllocationCollection
    include Playhouse::Role

    actor_dependency :id
    actor_dependency :allocations

    SUM_COLUMN = :amount_cents

    def total_allocation_balance
      Money.new(base_scope.sum(SUM_COLUMN))
    end

    def get_all_allocations
      base_scope
    end

    private

    def base_scope
      allocations
    end
  end
end
