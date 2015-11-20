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

  describe "#destroy" do
    before do
      @membership1 = create(:membership, member: user)
      @membership2 = create(:membership, member: user)

      @group1 = @membership1.group
      @group2 = @membership2.group

      @allocation1 = create(:allocation, user: user, group: @group1, amount: 420)
      @allocation2 = create(:allocation, user: user, group: @group2, amount: 420)

      @bucket1 = create(:bucket, group: @group1, user: user)
      @bucket2 = create(:bucket, group: @group2, user: user)

      @other_bucket1 = create(:bucket, group: @group1)
      @other_bucket2 = create(:bucket, group: @group2)

      @contribution1 = create(:contribution, user: user, bucket: @other_bucket1, amount: 200)
      @contribution2 = create(:contribution, user: user, bucket: @other_bucket2, amount: 200)

      @comment1 = create(:comment, user: user, bucket: @other_bucket1)
      @comment2 = create(:comment, user: user, bucket: @other_bucket2)

      user.destroy
    end

    it "destroys all user's memberships" do
      expect { @membership1.reload }.to raise_error
      expect { @membership2.reload }.to raise_error
    end

    it "destroys all user's allocations" do
      expect { @allocation1.reload }.to raise_error
      expect { @allocation2.reload }.to raise_error
    end

    it "destroys all user's buckets" do
      expect { @bucket1.reload }.to raise_error
      expect { @bucket2.reload }.to raise_error
    end

    it "destroys all user's contributions" do
      expect { @contribution1.reload }.to raise_error
      expect { @contribution2.reload }.to raise_error
    end

    it "destroys all user's comments" do
      expect { @comment1.reload }.to raise_error
      expect { @comment2.reload }.to raise_error
    end
  end
end