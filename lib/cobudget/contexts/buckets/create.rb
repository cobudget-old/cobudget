require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/composers/money_composer'
require 'playhouse/role'
require 'cobudget_theatre'
#require 'cobudget/roles/budget_administrator'

module Cobudget
  module Buckets
    class Create < Playhouse::Context
      class NotAuthorizedToCreateBucket < Exception; end

      actor :user, repository: User

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
        data = Bucket.create!(attributes)
        Pusher.trigger('cobudget', 'bucket_created', {bucket: data})
        data
      end
    end
  end
end
