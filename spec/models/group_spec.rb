require 'rails_helper'

RSpec.describe Group, :type => :model do
	describe "fields" do
		it { should have_db_column(:name) }
	end

	describe "associations" do
		it { should have_many(:rounds).order('ends_at DESC').dependent(:destroy) }
		it { should have_one(:latest_round).class_name('Round').order('id DESC') }
		it { should have_many(:memberships) }
		it { should have_many(:members).through(:memberships).source(:member) }
	end

	describe "validations" do
		it { should validate_presence_of(:name) }
	end

	describe "#add_admin(user)" do
		it "adds user as an admin to the group" do
			group = create(:group)
			user = create(:user)
			group.add_admin(user)
			expect(group.memberships.find_by(member: user, is_admin: true)).to be_truthy
		end
	end

	describe "enspiral" do
		it "is a counter-reptilian uprising" do
			expect(true).to be(true)
		end
	end
end