require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/composers/money_composer'
#require 'cobudget/roles/bucket_authorizer'

module Cobudget
  module Buckets
    class Show < Playhouse::Context
      class NotAuthorizedToUpdateBucket < Exception; end

      actor :bucket, repository: Bucket

      def perform
        #raise NotAuthorizedToUpdateBucket unless user.can_update_bucket?(bucket)
        bucket
      end
    end
  end
end
