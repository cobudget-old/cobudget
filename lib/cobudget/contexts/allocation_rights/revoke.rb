require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/user'
require 'cobudget/composers/money_composer'
require 'cobudget/roles/budget_participant'
require 'cobudget/roles/budget_of_accounts'
#require 'cobudget/roles/bucket_authorizer'

module Cobudget
  module AllocationRights
    class Revoke < Playhouse::Context
      class NotAuthorizedToRevokeAllocationRight < Exception; end

      actor :admin, repository: User

      actor :user, repository: User, role: BudgetParticipant
      actor :budget, repository: Budget, role: BudgetOfAccounts

      def attributes
        actors_except :admin
      end

      def perform
        user_account = user.get_allocation_rights(budget)
        budget_account = budget.get_budget_account

        raise NotAuthorizedToRevokeAllocationRight unless user.can_manage_budget?(budget)

        balance = TransactionCollection.cast_actor(user_account).balance

        Transfer.create(source_account: user_account, destination_account: budget_account, amount: balance)
      end
    end
  end
end