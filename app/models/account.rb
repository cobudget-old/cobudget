class Account < ActiveRecord::Base
  belongs_to :group

  def balance
  	debit = Transaction.where("to_account_id = ?", id).sum(:amount)
  	credit = Transaction.where("from_account_id = ?", id).sum(:amount)
  	debit-credit
  end
end
