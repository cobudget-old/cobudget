require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'

module Cobudget
  module Buckets
    class Create < Playhouse::Context
      actor :budget, repository: Budget
      actor :name
      actor :description, optional: true
      actor :sponsor, optional: true#, respository: User

      def perform
        Bucket.create!(actors)
      end
    end
  end
end