require 'playhouse/context'
require 'cobudget/entities/budget'

module Cobudget
  module Budgets
    class Create < Playhouse::Context
      actor :name
      actor :description, optional: true

      def perform
        data = Budget.create!(actors)
        Pusher.trigger('budgets', 'created', {budget: data})
        data
      end
    end
  end
end