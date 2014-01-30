require 'playhouse/context'
require 'cobudget/entities/user'

module Cobudget
  module Users
    class List < Playhouse::Context
      def perform
        User.all.as_json(include: { 
                           accounts: {
                             methods: :allocation_rights_cents
                           }
                         }
                        )
      end
    end
  end
end
