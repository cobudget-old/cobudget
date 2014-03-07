require 'playhouse/context'
require 'cobudget/entities/user'

module Cobudget
  module Users
    class Authenticate < Playhouse::Context
      actor :email
      actor :name

      def perform
        user = User.find_by_email(email)
        $logger.debug "***********USER*************"
        $logger.debug User.last.inspect
        $logger.debug User.last.email == email
        $logger.debug user.inspect
        if user
          user.last_sign_in_at = Time.now
          user.save
          user.as_json
        else
          User.create(actors).as_json
        end
      end 
    end 
  end 
end

