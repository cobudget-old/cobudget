require 'playhouse/context'
require 'cobudget/entities/transfer'
require 'cobudget/entities/account'
require 'cobudget/entities/user'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/roles/transfer_source'
require 'cobudget/roles/transfer_destination'
require 'cobudget/composers/money_composer'
require 'support/identifier'

module Cobudget
  class TransferMoney < Playhouse::Context
    class CannotTransferMoney < Exception; end
    class NotAuthorizedToTransferMoney < CannotTransferMoney; end
    class InsufficientFunds < CannotTransferMoney; end
    class InvalidTransferDestination < CannotTransferMoney; end
    class TransferFailed < Exception; end

    actor :source_account, role: TransferSource, repository: Account
    actor :destination_account, role: TransferDestination, repository: Account
    actor :creator, repository: User
    actor :amount, composer: MoneyComposer
    actor :time, optional: true
    actor :description, optional: true

    def transfer_arguments
      {
          creator_id: creator.id,
          description: description
      }
    end

    def perform
      raise InsufficientFunds unless source_account.can_decrease_money?(amount) || source_account.user.blank?
      raise InvalidTransferDestination unless source_account.budget == destination_account.budget

      begin
        ActiveRecord::Base.transaction do
          transfer = Transfer.create!(transfer_arguments)
          destination_account.increase_money!(amount, transfer, Identifier.generate)
          source_account.decrease_money!(amount, transfer, Identifier.generate)
        end
      rescue
        raise TransferFailed, "Transfer from '#{source_account.name}' to '#{destination_account.name}' failed."
      end
    end
  end
end