require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/account'
require 'cobudget/entities/user'
require 'cobudget/roles/budget_participant'

module Cobudget
  module Accounts
    class ListByBudget < Playhouse::Context
      class NotAuthorizedToListAccounts < Exception; end
      actor :budget, repository: Budget

      def perform
        accounts = [] 
        budget.accounts.order('updated_at desc').load.each do |acc|
          balance = EntryCollection.cast_actor(acc).balance.cents
          user_email = acc.user ? acc.user.email : nil
          acc = acc.attributes.merge!(:user_email => user_email, :balance => balance)
          accounts << acc
        end
        accounts
      end
    end
  end
end
