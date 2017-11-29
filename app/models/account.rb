class Account < ActiveRecord::Base
  belongs_to :group

  def balance
  	debit = Transaction.where(to_account_id: id).sum(:amount)
  	credit = Transaction.where(from_account_id: id).sum(:amount)
  	debit-credit
  end

  def change_account_to(acount_id)
    Transaction.where(to_account_id: id).find_each do |transaction|
      transaction.update(to_account_id: account_id)
    end
    Transaction.where(from_account_id: id).find_each do |transaction|
      transaction.update(from_ccount_id: account_id)
    end
  end
end
