require 'playhouse/context'
require 'cobudget/entities/user'
require 'cobudget/entities/account'
require 'cobudget/entities/budget'

module Cobudget
  module Accounts
    class Create < Playhouse::Context
      actor :admin, repository: User, optional: true
      actor :user, repository: User
      actor :budget, repository: Budget

      def get_actors
        actors_except(:admin)
      end

      def perform
        if user.blank?
          attributes = get_actors.merge(name: "#{budget.name} catchall bucket")
        else
          attributes = get_actors.merge(name: "#{user.name}'s account for #{budget.name}")
        end
        Account.create!(attributes)
      end
    end
  end
end