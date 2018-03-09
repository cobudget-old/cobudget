class DeliverCheckTransactionsEmail
  def self.check_transactions!
    if DateTime.now.utc.hour == 6
        UserMailer.check_transactions_email.deliver_later
    end
  end
end
