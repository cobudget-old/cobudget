require 'playhouse/role'

module Cobudget
  module TransferDestination
    include Playhouse::Role

    actor_dependency :id
    actor_dependency :balance, default_role: TransactionCollection

    def increase_money!(amount, transfer, identifier)
      Transaction.create!(amount: amount, transfer: transfer, account: self, identifier: identifier)
    end
  end
end