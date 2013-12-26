require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'

module Cobudget
  module Buckets
    class Archive < Playhouse::Context
      class NotAuthorizedToArchiveBucket < Exception; end

      actor :user, repository: User
      actor :bucket, repository: Bucket

      def perform
        #raise NotAuthorizedToArchiveBucket unless user.can_archive_bucket?(bucket)

        data = bucket.update_attributes!(archived: true)
        #Pusher.trigger('buckets', 'archived', {bucket: data})
      end
    end
  end
end
