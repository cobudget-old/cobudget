require 'playhouse/context'
require 'cobudget/entities/user'

module Cobudget
  module Users
    class List < Playhouse::Context
      def perform
        User.all
      end
    end
  end
end
