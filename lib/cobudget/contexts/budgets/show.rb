require 'playhouse/context'
require 'cobudget/entities/budget'

module Cobudget
  module Budgets
    class Show < Playhouse::Context
      class NotAuthorizedToViewBudget < Exception; end
      actor :budget, repository: Budget

      def perform
        budget.as_json
      end
    end
  end
end
