require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'

module Cobudget
  module Allocations
    class ListByBucket < Playhouse::Context
      #class NotAuthorizedToListAllocations < Exception; end
      actor :bucket, repository: Bucket

      def perform
        #Ideal
        bucket.allocations.as_json(include: :user)
      end
    end
  end
end
