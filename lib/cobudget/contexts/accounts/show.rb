require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/account'
require 'cobudget/entities/user'

module Cobudget
  module Accounts
    class Show < Playhouse::Context
      actor :account, repository: Account

      def perform
        account.as_json
      end
      #actor :budget, repository: Budget
      #actor :user, repository: User

      #def perform
        #Account.where(budget_id: budget.id, user_id: user.id).first
      #end
    end
  end
end
