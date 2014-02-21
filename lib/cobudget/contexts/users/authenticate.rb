require 'playhouse/context'
require 'cobudget/entities/user'

module Cobudget
  module Users
    class Authenticate < Playhouse::Context
      actor :email
      actor :name

      def perform
        user = User.find_by_email(email)
        if user
          user['last_sign_in_at'] = Time.now
          user.as_json
        else
          User.create(actors).as_json
        end
      end 
    end 
  end 
end

