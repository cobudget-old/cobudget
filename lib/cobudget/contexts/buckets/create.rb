require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/composers/money_composer'
require 'playhouse/role'
require 'pusher'
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

        #This wouldn't work with options in a core level so moved it here to test it.
        #Pusher.key = '6ea7addcc0137ddf6cf0'
        #Pusher.secret = '882cd62d5475bc7edee3'
        #Pusher.app_id = '59272'
        #Pusher.trigger('cobudget', 'bucket_created', {bucket: data})
        data
      end
    end
  end
end
