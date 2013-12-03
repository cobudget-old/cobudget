require 'playhouse/context'
require 'cobudget/entities/user'

module Cobudget
  module Users
    class List < Playhouse::Context
      def perform
        User.all#.order('updated_at desc').load
      end
    end
  end
end
