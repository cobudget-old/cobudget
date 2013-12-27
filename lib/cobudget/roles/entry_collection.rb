require 'playhouse/role'
require 'cobudget/entities/transaction'
require 'money'

module Cobudget
  module EntryCollection
    include Playhouse::Role

    SUM_COLUMN = :amount_cents

    actor_dependency :id
    actor_dependency :entries

    def balance
      Money.new(base_scope.sum(SUM_COLUMN))
    end

    def has_no_allocations?
      entries.count == 0
    end

    def is_empty?
      balance == 0
    end

    def balance_from_user(user)
      Money.new(from_user_scope(user).sum(SUM_COLUMN))
    end

    private

    def from_user_scope(user)
      user_account = Account.where(user: user).first # this is the user's account. self.id is the bucket

      transactions = Transaction.find_by_sql ["SELECT * FROM transactions WHERE
      transactions.id IN (SELECT transaction_id FROM entries WHERE account_id = #{user_account.id} AND account_type = 'Account') AND
      transactions.id IN (SELECT transaction_id FROM entries WHERE account_id = #{self.id} AND account_type = 'Bucket')"]

      #for some reason this returns an empty array []

      transactions.each do |t|
        puts t.account.name
        puts t.amount.to_s
      end

      transactions
    end

    def base_scope
      entries
    end
  end
end