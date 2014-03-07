require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/entities/comment'

module Cobudget
  module Comments
    class ListByBucket < Playhouse::Context
      actor :bucket, repository: Bucket

      def perform
        $logger.debug bucket.comments.map{|c| "#{c.depth}, #{c.body}"}
        comments = []
        bucket.comments.each do |c|
          if c.depth == 0
            comments << c
          end
        end
        comments.as_json
      end
    end
  end
end
