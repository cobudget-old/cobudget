require 'rails_helper'

RSpec.describe Group, :type => :model do
  describe "#add_admin(user)" do
    context "user already member of group" do
      it "makes the user an admin of group" do
        make_user_group_member
        group.add_admin(user)
        expect(group.memberships.find_by(member: user, is_admin: true)).to be_truthy
      end
    end

    context "user not member of group" do
      it "adds user as an admin to the group" do
        group = create(:group)
        user = create(:user)
        group.add_admin(user)
        expect(group.memberships.find_by(member: user, is_admin: true)).to be_truthy
      end
    end
  end

  describe "group balance calculations" do
    subject(:group)  { create(:group) }
    let(:bucket) { create(:bucket, group: group) }

    describe "#total_allocations" do
      it "calculates all allocations" do
        create(:allocation, group: group, amount: 100)
        create(:allocation, group: group, amount: 100.5)
        expect(subject.total_allocations).to eq 200.5
      end
    end

    describe "#total_contributions" do
      it "calculates all contributions" do
        create(:contribution, bucket: bucket, amount: 100)
        create(:contribution, bucket: bucket, amount: 100)
        expect(subject.total_contributions).to eq 200
      end
    end

    describe "#balance" do
      context "if no allocations or contributions" do
        it "returns 0" do
          expect(subject.balance).to eq(0)
        end
      end

      context "with allocations and contributions" do
        it "calculates the group balance" do
          create(:allocation, group: group, amount: 500)
          create(:allocation, group: group, amount: 100)
          create(:contribution, bucket: bucket, amount: 100)
          create(:contribution, bucket: bucket, amount: 100)
          # contribution factory creates an allocation equalling
          # the contribution amount
          expect(subject.reload.balance).to eq 600
        end

        it "rounds the balance down" do
          create(:allocation, group: group, amount: 500.50)
          expect(subject.reload.balance).to eq 500
        end
      end
    end
  end
end
