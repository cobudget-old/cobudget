require 'playhouse/role'
require 'cobudget/roles/budget_participant'
require 'cobudget/roles/entry_collection'

module Cobudget
  module TransferSource
    include Playhouse::Role

    actor_dependency :budget
    actor_dependency :balance
    actor_dependency :id

    def can_decrease_money?(amount)
      amount_money = amount
      unless amount.is_a?(Money)
        amount_money = Money.new(amount*100)
      end

      balance_money = balance
      unless balance.is_a?(Money)
        balance_money = Money.new(balance*100)
      end
      #puts "Decrease Money Check: BALANCE=" + balance_money.inspect
      #puts "Decrease Money Check: AMOUNT=" + amount_money.inspect

      balance_money - amount_money >= 0
      #balance - amount >= 0
    end

    def decrease_money!(amount, transfer, identifier)
      Entry.create!(amount: -amount, transfer: transfer, account: self, identifier: identifier)
    end

    private

    def accounts_in_same_budget?(transfer)
      self.budget == transfer.destination_account.budget
    end
  end
end