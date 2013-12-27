require 'playhouse/role'

module Cobudget
  module TransferDestination
    include Playhouse::Role

    actor_dependency :id
    actor_dependency :balance, default_role: EntryCollection

    def increase_money!(amount, transaction, identifier)
      Entry.create!(amount: amount, transaction: transaction, account: self, identifier: identifier)
    end
  end
end