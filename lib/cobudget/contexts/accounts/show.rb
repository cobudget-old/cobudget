require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/account'
require 'cobudget/entities/user'

module Cobudget
  module Accounts
    class Show < Playhouse::Context
      actor :account, repository: Account

      def perform
        balance = EntryCollection.cast_actor(account).balance
        user_email = account.user ? account.user.email : nil
        data = account.attributes.merge!(:user_email => user_email, :balance => balance)
        data
      end
      #actor :budget, repository: Budget
      #actor :user, repository: User

      #def perform
        #Account.where(budget_id: budget.id, user_id: user.id).first
      #end
    end
  end
end
