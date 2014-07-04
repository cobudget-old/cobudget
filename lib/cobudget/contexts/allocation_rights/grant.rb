require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/user'
require 'cobudget/composers/money_composer'
require 'cobudget/roles/budget_participant'
require 'cobudget/roles/budget_of_accounts'
require 'cobudget/roles/entry_collection'

module Cobudget
  module AllocationRights
    class Grant < Playhouse::Context
      class NotAuthorizedToGrantAllocationRight < Exception; end
      class BudgetNotFound < Exception; end
      class UserNotParticipating < Exception; end

      actor :current_user, repository: User

      actor :user, repository: User, role: BudgetParticipant
      actor :budget, repository: Budget, role: BudgetOfAccounts
      actor :amount

      def attributes
        actors_except :current_user
      end

      def perform
        admin =  User.find(current_user)
        user_accounts = user.get_allocation_rights(budget)
        budget_account = budget.get_budget_account

        raise NotAuthorizedToGrantAllocationRight unless admin.can_manage_budget?(budget)
        raise BudgetNotFound if budget_account.blank?

        if user_accounts.blank?
          user_account = Account.create!(user: user, budget: budget, name: "#{user.name}'s account for #{budget.name}'")
        else
          user_account = user_accounts.first
        end

        EntryCollection.cast_actor(budget_account)

        transfer = TransferMoney.new(source_account: budget_account, destination_account: user_account, amount: amount, creator: admin)
        transfer.call
        account = transfer.destination_account
        account.as_json
      end
    end
  end
end
