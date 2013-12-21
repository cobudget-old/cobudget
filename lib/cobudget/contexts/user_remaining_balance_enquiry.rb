require 'playhouse/context'
require 'cobudget/entities/user'
require 'cobudget/entities/budget'

module Cobudget
  class UserRemainingBalanceEnquiry < Playhouse::Context
    actor :user, role: BudgetParticipant, repository: User
    actor :budget, repository: Budget

    def perform
      user.balance_in_budget(budget)
    end
  end
end