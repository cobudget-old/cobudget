require 'playhouse/context'
require 'cobudget/entities/bucket'
require 'cobudget/entities/user'
require 'cobudget/entities/account'
require 'cobudget/composers/money_composer'

module Cobudget
  module Allocations
    class Create < Playhouse::Context
      class NotAuthorizedToAllocate < Exception; end
      class InvalidAmount < Exception; end

      actor :current_user, repository: User

      actor :user, repository: User, role: BudgetParticipant
      actor :bucket, repository: Bucket, role: EntryCollection
      actor :amount, composer: MoneyComposer

      def get_attributes
        actors_except :current_user
      end

      def perform
        creator = User.find(current_user)
        raise NotAuthorizedToAllocate unless user.can_allocate?(bucket)

        user_account = user.get_allocation_rights(bucket.budget).first
        transfer = TransferMoney.new(source_account: user_account, destination_account: bucket, amount: amount, creator: creator)
        Pusher.trigger('cobudget', 'allocation_updated', {user_id: user.id, bucket_id: bucket.id, amount: amount})
        transfer.call
      end
    end
  end
end
