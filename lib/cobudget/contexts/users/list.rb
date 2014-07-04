require 'playhouse/context'
require 'cobudget/entities/user'

module Cobudget
  module Users
    class List < Playhouse::Context
      class NotAuthorizedToListUsers < Exception; end

      actor :current_user
      def perform
        id = current_user
        current_user = User.find(id)
        raise NotAuthorizedToListUsers unless current_user.can_manage_accounts?
        User.all.as_json
      end
    end
  end
end
