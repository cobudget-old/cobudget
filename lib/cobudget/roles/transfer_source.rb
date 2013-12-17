require 'playhouse/role'
require 'cobudget/roles/budget_participant'
require 'cobudget/roles/transaction_collection'

module Cobudget
  module TransferSource
    include Playhouse::Role

    actor_dependency :budget
    actor_dependency :balance
    actor_dependency :id

    def can_decrease_money?(amount)
      amount_money = Money.new(amount)
      balance_money = Money.new(amount)
      puts "BALANCE=" + balance.inspect
      puts "AMOUNT=" + amount.inspect

      balance_money - amount_money >= 0
    end

    def decrease_money!(amount, transfer, identifier)
      Transaction.create!(amount: -amount, transfer: transfer, account: self, identifier: identifier)
    end

    private

    def accounts_in_same_budget?(transfer)
      self.budget == transfer.destination_account.budget
    end
  end
end