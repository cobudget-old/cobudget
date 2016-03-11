require 'rails_helper'

RSpec.describe Allocation, :type => :model do
	describe "#formatted_amount" do
		it "returns allocation amount, round to two decimal places with $ in front" do
			allocation = create(:allocation, amount: 234.50)
			expect(allocation.formatted_amount).to eq("$234.50")
		end
	end

  describe "#create" do
    context "amount would overdraft member" do
      it "does not validate record and throws error" do
        make_user_group_member
        create(:allocation, user: user, group: group, amount: 100)
        expect{create(:allocation, user: user, group: group, amount: -101)}.to raise_error
      end
    end
  end
end
