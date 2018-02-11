require 'rails_helper'

RSpec.describe Group, :type => :model do
  after { ActionMailer::Base.deliveries.clear }
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

        it "doesn't round the balance down" do
          create(:allocation, group: group, amount: 500.50)
          expect(subject.reload.balance).to eq 500.50
        end
      end
    end
  end

  describe "membership cleanup" do
    context "by moving funds from archived member to group account" do
      before do
        admins = create_list(:user, 2)
        admins.each { |a| group.add_admin(a) }
        normal_users = create_list(:user, 3)
        @normal_memberships = normal_users.map { |u| group.add_member(u) }
        normal_users.each { |u| create(:allocation, user: u, group: group, amount: 10) }
        @normal_memberships.each { |m| create(:transaction, from_account_id: m.incoming_account_id, 
          to_account_id: m.status_account_id, user_id: user.id, amount: 10) }
        archived_users = create_list(:user, 3)
        @archived_memberships = archived_users.map { |u| group.add_member(u) }
        archived_users.each { |u| create(:allocation, user: u, group: group, amount: 7) }
        @archived_memberships.each { |m| create(:transaction, from_account_id: m.incoming_account_id, 
          to_account_id: m.status_account_id, user_id: user.id, amount: 7) }
        @archived_memberships.each { |m| m.archive! }
        group.cleanup_archived_members_with_funds(group.ensure_group_user_exist())
        @group_membership = group.ensure_group_account_exist()
      end

      it "has moved funds from archived users" do
        @archived_memberships.each do |m|
          expect(m.raw_balance).to eq(0)
          expect(Account.find(m.status_account_id).balance).to eq(0)
        end
      end

      it "has not touched funds in non-archived users" do
        @normal_memberships.each do |m|
          expect(m.raw_balance).to eq(10)
          expect(Account.find(m.status_account_id).balance).to eq(10)
        end
      end

      it "has moved the funds from echived users to group account" do
        expect(@group_membership.raw_balance).to eq(21)
        expect(Account.find(@group_membership.status_account_id).balance).to eq(21)
      end

      it "sends mails to admins" do
        sent_emails = ActionMailer::Base.deliveries
        recipients = sent_emails.map { |email| email.to.first }
        admin_emails = Membership.where(group_id: group.id, is_admin: :true).map { |admin| admin.member.email }
        expect(recipients).to match_array(admin_emails)
        expect(sent_emails.first.body).to include("transferred")
      end
    end
  end
end
