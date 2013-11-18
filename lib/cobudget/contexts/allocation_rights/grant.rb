require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/user'
require 'cobudget/entities/allocation_right'
require 'cobudget/composers/money_composer'
require 'cobudget/roles/budget_participant'
#require 'cobudget/roles/bucket_authorizer'

module Cobudget
  module AllocationRights
    class Grant < Playhouse::Context
      class NotAuthorizedToGrantAllocationRight < Exception; end

      actor :admin, repository: User#, role: BucketAuthorizer

      actor :user, repository: User, role: BudgetParticipant
      actor :budget, repository: Budget
      actor :amount

      def attributes
        actors_except :admin
      end

      def perform
        right = user.get_allocation_rights(budget)
        if right
          right.update(attributes)
        else
          AllocationRight.create!(attributes)
        end
      end
    end
  end
end