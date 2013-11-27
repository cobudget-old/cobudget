require 'playhouse/context'
require 'cobudget/roles/allocator'
require 'cobudget/entities/user'
require 'cobudget/entities/budget'

module Cobudget
  class UserRemainingBalanceEnquiry < Playhouse::Context
    actor :user, role: Allocator, repository: User
    actor :budget, repository: Budget

    def perform
      user.remaining_allocation_balance(budget)
    end
  end
end