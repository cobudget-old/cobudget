require 'playhouse/context'
require 'cobudget/entities/user'

module Cobudget
  module Users
    class Update < Playhouse::Context
      class NotAuthorizedToUpdateUser < Exception; end
      actor :user, repository: User
      actor :name, optional: true
      actor :email
      actor :bg_color, optional: true
      actor :fg_color, optional: true
      actor :role, optional: true

      def attributes
        actors_except :user
      end

      def perform
        data = user.update_attributes!(attributes)
        #Pusher.trigger('budgets', 'updated', {budget: data})
        user.as_json
      end
    end
  end
end
