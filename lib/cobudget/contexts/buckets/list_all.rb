require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'

module Cobudget
  module Buckets
    class ListAll < Playhouse::Context
      class NotAuthorizedToListAllBuckets < Exception; end

      actor :budget, repository: Budget
      actor :admin, repository: User

      def perform
        #raise NotAuthorizedToListAllBuckets if admin.can_list_all_buckets?

        budget.buckets.order('updated_at desc').load.as_json
      end
    end
  end
end
