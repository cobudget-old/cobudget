require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/account'

module Cobudget
  module Budgets
    class Create < Playhouse::Context
      actor :name
      actor :description, optional: true

      def perform
        data = Budget.create!(actors)
        Account.create(budget: data, name: "#{data.name} catchall bucket")
        #Pusher.trigger('budgets', 'created', {budget: data})
        data
      end
    end
  end
end
