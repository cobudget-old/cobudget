require 'playhouse/context'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/composers/money_composer'

module Cobudget
  module Buckets
    class Create < Playhouse::Context
      actor :budget, repository: Budget
      actor :name
      actor :description, optional: true
      actor :minimum, composer: MoneyComposer, optional: true
      actor :maximum, composer: MoneyComposer, optional: true
      actor :sponsor, repository: User, optional: true

      def perform
        Bucket.create!(actors)
      end
    end
  end
end