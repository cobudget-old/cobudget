require 'playhouse/context'
require 'cobudget/contexts/accounts/create'
require 'cobudget/entities/user'

module Cobudget
  module Users
    class Create < Playhouse::Context
      actor :name, optional: true
      actor :email

      def perform
        data = User.create!(actors)
        #create_accounts(user: user)
        data
      end
    end
  end
end