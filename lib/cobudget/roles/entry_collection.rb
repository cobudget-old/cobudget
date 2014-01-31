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
      sum = 0
      from_user_scope(user).each do |t|
        sum += t.entries.where("account_type = 'Cobudget::Bucket'").first.amount.cents
      end
      sum
    end

    private

    def from_user_scope(user)
      user_account = Account.where(user: user).first # this is the user's account. self.id is the bucket

      Transaction.find_by_sql ["SELECT * FROM transactions WHERE
      transactions.id IN (SELECT transaction_id FROM entries WHERE entries.account_id = ? AND entries.account_type = 'Cobudget::Account') AND
      transactions.id IN (SELECT transaction_id FROM entries WHERE entries.account_id = ? AND entries.account_type = 'Cobudget::Bucket')", user_account.id, self.id]
    end

    def base_scope
      entries
    end
  end
end
