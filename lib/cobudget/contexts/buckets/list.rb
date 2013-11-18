require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'

module Cobudget
  module Buckets
    class List < Playhouse::Context
      actor :budget, repository: Budget

      def perform
        budget.buckets.order('updated_at desc').load
      end
    end
  end
end
