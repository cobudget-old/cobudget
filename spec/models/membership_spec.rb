require 'rails_helper'

RSpec.describe Membership, :type => :model do
	 describe "Accounts attached" do
    it "has an incoming, outgoing and status account with a zero balance" do
      membership = create(:membership)
      expect(membership.incoming_account_id).to be > 0
      expect(membership.outgoing_account_id).to be > 0
      expect(membership.status_account_id).to be > 0
      expect(Account.find(membership.incoming_account_id).balance).to eq(0.0)
      expect(Account.find(membership.outgoing_account_id).balance).to eq(0.0)
      expect(Account.find(membership.status_account_id).balance).to eq(0.0)
    end
  end
end