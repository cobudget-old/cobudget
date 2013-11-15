require 'playhouse/context'
require 'cobudget/entities/budget'

module Cobudget
  module Budgets
    class Create < Playhouse::Context
      actor :name
      actor :description, optional: true

      def perform
        Budget.create!(actors)
      end
    end
  end
end