require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/composers/money_composer'
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
      actor :minimum, composer: MoneyComposer, optional: true
      actor :maximum, composer: MoneyComposer, optional: true

      def attributes
        actors_except :bucket, :user
      end

      def perform
        #raise NotAuthorizedToUpdateBucket unless user.can_update_bucket?(bucket)

        data = bucket.update_attributes!(attributes)
        Pusher.trigger('buckets', 'updated', {bucket: data})
      end
    end
  end
end
