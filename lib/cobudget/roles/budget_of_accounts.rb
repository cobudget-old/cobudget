require 'playhouse/role'
require 'cobudget/entities/budget'

module Cobudget
  module BudgetOfAccounts
    include Playhouse::Role

    actor_dependency :accounts

    def balance
      base_scope.to_a.sum do |account|
        EntryCollection.cast_actor(account).balance unless account.user.blank?
      end
    end

    def get_budget_account
      base_scope.first
    end

    private

    def base_scope
      accounts
    end
  end
end