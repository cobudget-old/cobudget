require 'playhouse/role'
require 'cobudget/roles/account_holder'

module Cobudget
  module TransferSource
    include Playhouse::Role

    actor_dependency :minimum_balance
    actor_dependency :budget
    actor_dependency :balance, default_role: AccountHolder
    actor_dependency :id

    def can_decrease_money?(amount)
      if minimum_balance
        balance - amount > minimum_balance
      else
        true
      end
    end

    def decrease_money!(amount, transfer)
      Transaction.create!(amount: -amount, transfer: transfer, account: self)
    end

    private

    def accounts_in_same_budget?(transfer)
      self.budget == transfer.destination_account.budget
    end
  end
end