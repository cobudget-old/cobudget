require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'

module Cobudget
  module Buckets
    class List < Playhouse::Context
      actor :budget, repository: Budget

      def perform
        budget.buckets.load
      end

      private

      def buckets_scope
        user.filter_accounts_by_viewable(budget.buckets).readonly
      end
    end
  end
end