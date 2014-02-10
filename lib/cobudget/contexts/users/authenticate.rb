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
          user.as_json( include: { 
                        accounts: {
                            methods: :allocation_rights_cents
                        }
                      }
                    )
        else
          User.create(actors).as_json( include: { 
                        accounts: {
                            methods: :allocation_rights_cents
                        }
                      }
                    )
        end
      end 
    end 
  end 
end

