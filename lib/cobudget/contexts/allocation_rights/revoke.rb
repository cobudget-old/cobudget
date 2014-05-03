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
      class NoAllocationRightsToRevoke < Exception; end

      actor :admin, repository: User

      actor :user, repository: User, role: BudgetParticipant
      actor :budget, repository: Budget, role: BudgetOfAccounts

      def attributes
        actors_except :admin
      end

      def perform
        user_accounts = user.get_allocation_rights(budget)
        budget_account = budget.get_budget_account

        raise NotAuthorizedToRevokeAllocationRight unless admin.can_manage_budget?(budget)
        raise NoAllocationRightsToRevoke if user_accounts.blank?

        user_account = user_accounts.first
        balance = EntryCollection.cast_actor(user_account).balance

        transfer = TransferMoney.new(source_account: user_account, destination_account: budget_account, amount: (balance/100).to_f, creator: admin)
        transfer.call

        user_account.delete
      end
    end
  end
end