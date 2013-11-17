require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/user'

module Cobudget
  module Budgets
    class Update < Playhouse::Context
      class NotAuthorizedToUpdateBudget < Exception; end

      actor :user, repository: User
      actor :budget, repository: Budget

      actor :name, optional: true
      actor :description, optional: true

      def attributes
        actors_except :budget, :user
      end

      def perform
        #raise NotAuthorizedToUpdateBudget unless user.can_update_budget?(budget)

        budget.update_attributes!(attributes)
      end
    end
  end
end
