require 'spec_helper'
require 'cobudget/contexts/transfer_money'

module Cobudget
  describe TransferMoney do
    let(:creator) {FactoryGirl.create(:user)}
    let(:source_account) {FactoryGirl.create(:account)}
    let(:destination_account) {FactoryGirl.create(:account, budget: source_account.budget)}

    subject do
      TransferMoney.new(
        source_account: source_account,
        destination_account: destination_account,
        creator: creator,
        amount: 100
      )
    end

    context 'source account does not have enough funds' do
      before(:each) do
        subject.source_account.stub('can_decrease_money?').and_return false
      end
      it 'raises insufficient funds exception if the account has a user' do
        subject.source_account.stub(:user).and_return creator
        expect {
          subject.call
        }.to raise_error(TransferMoney::InsufficientFunds)
      end

      it 'does not raise an exception if the account has no user' do
        expect {
          subject.call
        }.not_to raise_error
      end
    end

    context 'source and destination accounts are in different budgets' do
      it 'raises an invalid transfer destination error' do
        subject.source_account.stub(:budget).and_return Budget.new
        expect {
          subject.call
        }.to raise_error(TransferMoney::InvalidTransferDestination)
      end
    end

    context 'there is an error processing the transaction' do
      before(:each) do
        subject.source_account.stub(:decrease_money!).and_raise(Exception)
      end
      it 'rolls back the database' do
        subject.stub(:raise)
        expect {
          subject.call
        }.not_to(change {Transaction.count})
      end
      it 'raises a TransferFailed Exception' do
        expect {
          subject.call
        }.to(raise_error(TransferMoney::TransferFailed))
      end
    end

    context 'a successful transfer' do
      it 'creates a transaction object' do
        expect {
          subject.call
        }.to change {Transaction.count}.by(1)
      end
      it 'calls decrease money on source account' do
        source_account.should_receive(:decrease_money!)
        subject.call
      end
      it 'calls increase money on destination account' do
        destination_account.should_receive(:increase_money!)
        subject.call
      end
    end
  end
end
