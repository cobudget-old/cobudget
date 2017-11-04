class AccountService
  def self.balance(account_id)
    debit = Transaction.where("to_account_id = ?", account_id).sum(:amount)
    credit = Transaction.where("from_account_id = ?", account_id).sum(:amount)
    debit-credit
  end
end
