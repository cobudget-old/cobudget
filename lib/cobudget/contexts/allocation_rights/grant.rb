require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/user'
require 'cobudget/composers/money_composer'
require 'cobudget/roles/budget_participant'
require 'cobudget/roles/account_holder'
require 'cobudget/roles/budget_of_accounts'
require 'cobudget/roles/transaction_collection'

module Cobudget
  module AllocationRights
    class Grant < Playhouse::Context
      class NotAuthorizedToGrantAllocationRight < Exception; end
      class BudgetNotFound < Exception; end
      class UserNotParticipating < Exception; end

      actor :admin, repository: User

      actor :user, repository: User, role: BudgetParticipant
      actor :budget, repository: Budget, role: BudgetOfAccounts
      actor :amount, composer: MoneyComposer

      def attributes
        actors_except :admin
      end

      def perform
        user_account = user.get_allocation_rights(budget)
        budget_account = budget.get_budget_account

        raise NotAuthorizedToRevokeAllocationRight unless user.can_manage_budget?(budget)
        raise BudgetNotFound if budget_account.blank?
        if user_account.blank?
          user_account = Account.create!(user: user, budget: budget, name: "#{user.name}'s account for #{budget.name}'")
        end

        Transfer.create(source_account: user_account, destination_account: budget_account, amount: amount)
      end
    end
  end
end