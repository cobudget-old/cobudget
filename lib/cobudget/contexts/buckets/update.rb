require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
#require 'cobudget/roles/bucket_authorizer'

module Cobudget
  module Buckets
    class Update < Playhouse::Context
      class NotAuthorizedToUpdateBucket < Exception; end

      actor :user, repository: User#, role: BucketAuthorizer
      actor :bucket, repository: Bucket

      actor :budget, repository: Budget
      actor :name, optional: true
      actor :description, optional: true
      actor :sponsor, optional: true, repository: User
      actor :minimum, optional: true
      actor :maximum, optional: true

      def attributes
        actors_except :bucket, :user
      end

      def perform
        #raise NotAuthorizedToUpdateBucket unless user.can_update_bucket?(bucket)

        bucket.update_attributes(attributes)
      end
    end
  end
end
