require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/account'
require 'cobudget/entities/user'

module Cobudget
  module Accounts
    class ListByBudget < Playhouse::Context
      class NotAuthorizedToListAccounts < Exception; end
      actor :budget, repository: Budget
      actor :admin, repository: User

      def perform
        accounts = [] 
        budget.accounts.order('updated_at desc').load.each do |acc|
          acc = acc.attributes.merge!(:user_email => acc.user.email)
          accounts << acc
        end
        accounts
      end
    end
  end
end
