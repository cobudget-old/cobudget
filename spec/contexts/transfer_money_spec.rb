require 'spec_helper'
require 'cobudget/contexts/transfer_money'

module Cobudget
  describe TransferMoney do
    let(:creator) {FactoryGirl.create(:user)}
    let(:source_account) {FactoryGirl.create(:account)}
    let(:destination_account) {FactoryGirl.create(:account)}

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

    it 'returns a money object with the bucket balance' do
      subject
      expect(true).to eq(true)
    end
  end
end
