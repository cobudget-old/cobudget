require 'playhouse/role'

module Cobudget
  module TransferDestination
    include Playhouse::Role

    actor_dependency :id

    def increase_money!(amount, transfer, identifier)
      Transaction.create!(amount: amount, transfer: transfer, account: self, identifier: identifier)
    end
  end
end