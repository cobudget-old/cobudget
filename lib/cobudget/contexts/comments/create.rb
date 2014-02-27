require 'playhouse/context'
require 'cobudget/entities/user'
require 'cobudget/entities/bucket'
require 'cobudget/entities/comment'

module Cobudget
  module Comments
    class Create < Playhouse::Context
      actor :current_user
      actor :comment, repository: Comment, optional: true
      actor :bucket, repository: Bucket
      actor :body

      def perform
        user = User.find(current_user)
        if comment
          actors = actors_except :current_user, :comment
          new_comment = Comment.children_of(comment.id).new(actors)
          new_comment.user = user
          new_comment.save!
        else
          actors = actors_except :current_user
          #for nesting actors except comment, but find it and create on it
          new_comment = Comment.new(actors)
          new_comment.user = user
          new_comment.save!
        end

        Pusher.trigger('cobudget', 'comment_created', {bucket_id: bucket.id, comment: new_comment.as_json, parent_id: new_comment.parent_id})
        new_comment.as_json
      end
    end
  end
end
