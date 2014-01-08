require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/account'

module Cobudget
  include ActiveModel::Serialization
  module Budgets
    class List < Playhouse::Context
      class NotAuthorizedToListAllBudgets < Exception; end
      def perform
        Budget.all
      end
    end
  end
end
