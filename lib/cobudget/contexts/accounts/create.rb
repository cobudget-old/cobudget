require 'playhouse/context'
require 'cobudget/entities/user'
require 'cobudget/entities/account'

module Cobudget
  module Accounts
    class Create < Playhouse::Context
      actor :user, repository: User

      def perform
        Account.create!(actors)
      end
    end
  end
end