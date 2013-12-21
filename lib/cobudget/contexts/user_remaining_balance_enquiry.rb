require 'playhouse/context'
require 'cobudget/entities/user'
require 'cobudget/entities/budget'
require 'cobudget/roles/budget_participant'

module Cobudget
  class UserRemainingBalanceEnquiry < Playhouse::Context
    actor :user, repository: User, role: BudgetParticipant
    actor :budget, repository: Budget

    def perform
      user.balance_in_budget(budget)
    end
  end
end
