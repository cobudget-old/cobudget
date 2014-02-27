require 'playhouse/context'
require 'cobudget/entities/user'
require 'cobudget/entities/comment'

module Cobudget
  module Comments
    class Delete < Playhouse::Context
      actor :current_user
      actor :comment, repository: Comment

      def perform
        data = comment.destroy
        data
      end
    end
  end
end
