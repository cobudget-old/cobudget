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
      #puts "Balance = #{Money.new(base_scope.sum(SUM_COLUMN))}"
      Money.new(base_scope.sum(SUM_COLUMN)).cents
    end

    def has_no_allocations?
      entries.count == 0
    end

    def is_empty?
      balance == 0
    end

    def balance_from_user(user, budget_id)
      sum = 0
      from_user_scope(user, budget_id).each do |t|
        puts t.entries.where("account_type = 'Cobudget::Bucket'").inspect
        sum += t.entries.where("account_type = 'Cobudget::Bucket'").first.amount_cents
      end
      sum
    end

    private

    def from_user_scope(user, budget_id)
      user_account = Account.where(user: user, budget_id: budget_id).first # this is the user's account. self.id is the bucket

      Transaction.find_by_sql ["SELECT * FROM transactions WHERE
      transactions.id IN (SELECT transaction_id FROM entries WHERE entries.account_id = ? AND entries.account_type = 'Cobudget::Account') AND
      transactions.id IN (SELECT transaction_id FROM entries WHERE entries.account_id = ? AND entries.account_type = 'Cobudget::Bucket')", user_account.id, self.id]
    end

    def base_scope
      entries
    end
  end
end
