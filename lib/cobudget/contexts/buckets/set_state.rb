require 'playhouse/context'
require 'cobudget/entities/bucket'

module Cobudget
  module Buckets
    class SetState < Playhouse::Context
      class NotAuthorizedToUpdateBucket < Exception; end
      actor :bucket, repository: Bucket
      actor :state

      def perform
        puts state == "funded"
        puts actors.inspect
        if state == "funded"
          bucket.set_funded!
          bucket.as_json
        end
        if state == "cancelled"
          bucket.set_cancelled!
          bucket.as_json
        end
        #Pusher.trigger('cobudget', 'bucket_updated', {bucket: bucket.as_json})
      end
    end
  end
end
