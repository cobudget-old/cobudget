require 'playhouse/role'
require 'cobudget/entities/allocation'
require 'money'

module Cobudget
  module Allocator
    include Playhouse::Role

    actor_dependency :id
    actor_dependency :allocations
    actor_dependency :whaargarbl

    SUM_COLUMN = :amount_cents

    def get_allocation_for_bucket(bucket)
      allocations.where(bucket_id: bucket.id).first
    end

    def total_allocations_for_budget(budget)
      allocations.where(budget: budget)

      Money.new(budget_scope(budget).sum(SUM_COLUMN))
    end

    def remaining_allocation_balance(budget)
      #rights = BudgetParticipant.cast_actor(self).allocation_rights_total(budget)
      #allocations = total_allocations_for_budget(budget)

      #rights.to_f - allocations.to_f
      rights = BudgetParticipant.cast_actor(self).allocation_rights_total(budget)
    end

    def can_allocate?(bucket)
      rights = BudgetParticipant.cast_actor(self).has_allocation_rights?(bucket.budget)
    end

    private

    def budget_scope(budget)
      # there are far better ways to do that but I'm too tired to wrangle the sql
      data = []
      budget.buckets.each do |b|
        data.append b.id
      end
      Allocation.where(bucket_id: data, user_id: self.id)

      # get
    end
  end
end

