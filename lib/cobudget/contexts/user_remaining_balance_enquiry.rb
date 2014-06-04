require 'playhouse/context'
require 'playhouse/loader'

module Cobudget
  entities :user, :budget
  role :budget_participant

  class UserRemainingBalanceEnquiry < Playhouse::Context
    actor :user, repository: User, role: BudgetParticipant
    actor :budget, repository: Budget

    def perform
      Money.new user.balance_in_budget(budget)
    end
  end
end
