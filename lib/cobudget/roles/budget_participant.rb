require 'playhouse/role'
require 'money'

module Cobudget
  module BudgetParticipant
    include Playhouse::Role

    actor_dependency :id
    actor_dependency :accounts

    SUM_COLUMN = :amount_cents

    def allocation_rights_total(budget)
      Money.new(accounts_in_budget(budget).map(&:balance).sum)
      #this should really add up the allocation rights a user has been given
    end

    def has_allocation_rights?(budget)
      !accounts_in_budget(budget).blank?
    end

    def get_allocation_rights(budget)
      accounts_in_budget(budget)
    end

    def can_allocate?(bucket)
      has_allocation_rights?(bucket.budget)
    end

    def balance_in_budget(budget)
      Money.new(accounts_in_budget(budget).map(&:balance).sum)
    end

    private

    def accounts_in_budget(budget)
      the_accounts = accounts.where(budget: budget).to_a
      the_accounts.each do |account|
        TransactionCollection.cast_actor(account)
      end
      the_accounts
    end
  end
end
