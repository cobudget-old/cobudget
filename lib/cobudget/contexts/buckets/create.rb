require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/composers/money_composer'
#require 'cobudget/roles/bucket_authorizer'

module Cobudget
  module Buckets
    class Create < Playhouse::Context
      class NotAuthorizedToCreateBucket < Exception; end

      actor :user, repository: User#, role: BucketAuthorizer

      actor :budget, repository: Budget
      actor :name
      actor :description, optional: true
      actor :minimum, composer: MoneyComposer, optional: true
      actor :maximum, composer: MoneyComposer, optional: true
      actor :sponsor, repository: User, optional: true

      def attributes
        actors_except :user
      end

      def perform
        #raise NotAuthorizedToCreateBucket unless user.can_create_bucket?(bucket)
        Bucket.create!(attributes)
      end
    end
  end
end