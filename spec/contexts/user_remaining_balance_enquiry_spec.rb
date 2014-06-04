require 'spec_helper'
require 'cobudget/contexts/user_remaining_balance_enquiry'

module Cobudget
  describe UserRemainingBalanceEnquiry do
    let(:user) {FactoryGirl.create(:user)}
    subject { UserRemainingBalanceEnquiry.new(budget: Budget.new, user: user) }

    it "returns a money object with user's balance in budget" do
      subject.user.stub(:balance_in_budget).and_return(20)
      expect(subject.call).to eq(Money.new(20))
    end
  end
end
