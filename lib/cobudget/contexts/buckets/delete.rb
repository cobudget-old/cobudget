require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'

module Cobudget
  module Buckets
    class Delete < Playhouse::Context
      class NotAuthorizedToDeleteBucket < Exception; end

      actor :user, repository: User
      actor :bucket, repository: Bucket

      def perform
        #raise NotAuthorizedToCreateBucket unless user.can_create_bucket?(bucket)
        data = bucket.destroy!
        #Pusher.trigger('buckets', 'deleted', {bucket: data})
      end
    end
  end
end