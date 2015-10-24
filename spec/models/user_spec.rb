require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { create(:user) }
  let(:membership) { create(:membership, member: user) }
  let(:admin_membership) { create(:membership, member: user, is_admin: true) }

	describe "#name_and_email" do
		it "returns formatted name and email, formatted for email" do
			expect(user.name_and_email).to eq("#{user.name} <#{user.email}>")
		end
	end

	describe "#is_admin_for?(group)" do
		it "returns false if user isn't admin of group" do
		  expect(user.is_admin_for?(membership.group)).to eq false
		end
		
		it "returns true if user is admin of group" do
		  expect(user.is_admin_for?(admin_membership.group)).to eq true
		end
	end

	describe "#is_member_of?(group)" do
		it "returns false if user isn't a member of group" do
			make_user_group_member
			expect(user.is_member_of?(group)).to eq(true)
		end

		it "returns true if user is a member of the group" do
			expect(user.is_member_of?(group)).to eq(false)
		end
	end
end