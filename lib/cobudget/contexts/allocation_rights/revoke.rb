require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/user'
require 'cobudget/entities/allocation_right'
require 'cobudget/composers/money_composer'
require 'cobudget/roles/budget_participant'
#require 'cobudget/roles/bucket_authorizer'

module Cobudget
  module AllocationRights
    class Revoke < Playhouse::Context
      class NotAuthorizedToRevokeAllocationRight < Exception; end

      actor :admin, repository: User#, role: BucketAuthorizer

      actor :user, repository: User, role: BudgetParticipant
      actor :budget, repository: Budget

      def attributes
        actors_except :admin
      end

      def perform
        right = user.get_allocation_rights(budget)
        right.delete(right.all) unless right.nil?
      end
    end
  end
end