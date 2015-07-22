require 'rails_helper'

RSpec.describe Group, :type => :model do
	describe "#add_admin(user)" do
		it "adds user as an admin to the group" do
			group = create(:group)
			user = create(:user)
			group.add_admin(user)
			expect(group.memberships.find_by(member: user, is_admin: true)).to be_truthy
		end
	end

  describe "#balance_for(user)" do
    it "returns the difference between total allocations and contributions of a user within the group" do
      make_user_group_member
      proposer = create(:user)
      bucket = create(:bucket, group: group, user: proposer)    

      4.times { create(:allocation, user: user, group: group, amount: 20)} # user allocated $80
      2.times { create(:contribution, user: user, bucket: bucket, amount: 10) } # user contributes $20

      expect(group.balance_for(user)).to eq(60)
    end
  end
end