require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/entities/comment'

module Cobudget
  module Comments
    class ListByBucket < Playhouse::Context
      actor :bucket, repository: Bucket

      def perform
        data = bucket.comments
        data.as_json
      end
    end
  end
end
