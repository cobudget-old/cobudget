require "rails_helper"

#
# @group = create(:group)
# @admin_user = create(:user)
# @admin_membership = create(:membership, member: @admin_user, group: @group, is_admin: true)
# @bucket = create(:bucket, user: @admin_user, group: @group, status: "live")
#
# @user = create(:user)
# @membership = create(:membership, member: @user, group: @group)
#
# # create an archived participant
# @archived_participant = create_bucket_participant(bucket: @bucket, subscribed: true)
# Membership.find_by(group: @bucket.group, member: @archived_participant).update(archived_at: DateTime.now.utc - 5.days)
#
# @archived_participant2 = create_bucket_participant(bucket: @bucket, subscribed: true)
# Membership.find_by(group: @bucket.group, member: @archived_participant2).update(archived_at: DateTime.now.utc - 5.days)
#

require "csv"

def generate_parsed_csv_with_user(user: , allocation_amount: )
  [[user.email, allocation_amount]]
end

describe "AllocationService" do
  after do
    ActionMailer::Base.deliveries.clear
  end

  describe "#create_allocations_from_csv(parsed_csv: , group: , current_user:)" do
    let!(:current_user) { create(:user) }
    let!(:group) { create(:group) }

    context "user exists" do
      let!(:user) { create(:user) }

      context "membership exists, but is archived" do
        let!(:archived_membership) { create(:archived_membership, member: user, group: group) }

        before do
          parsed_csv = generate_parsed_csv_with_user(user: user, allocation_amount: 420)
          AllocationService.create_allocations_from_csv(parsed_csv: parsed_csv, group: group, current_user: current_user)
        end

        it "membership is reactivated" do
          expect(archived_membership.reload.active?).to be_truthy
        end

        it "user receives 'invite to group' email" do
          sent_email = ActionMailer::Base.deliveries.first
          expect(sent_email.body.to_s).to include("#{current_user.name} has invited you to collaboratively budget with everyone else at #{group.name}. You've got $420.00 to spend!")
        end

        it "user receives allocation" do
          expect(Allocation.find_by(user: user, amount: 420, group: group)).to be_truthy
        end
      end

      context "membership exists and is active" do
        let!(:active_membership) { create(:membership, member: user, group: group)}

        before do
          parsed_csv = generate_parsed_csv_with_user(user: user, allocation_amount: 420)
          AllocationService.create_allocations_from_csv(parsed_csv: parsed_csv, group: group, current_user: current_user)
        end

        it "user receives 'allocation' email" do
          sent_email = ActionMailer::Base.deliveries.first
          expect(sent_email.body.to_s).to include("You’ve received $420.00 to fund projects with #{group.name} in Cobudget!")
        end

        it "user receives allocation" do
          expect(Allocation.find_by(user: user, amount: 420, group: group)).to be_truthy
        end
      end

      context "membership doesn't exist" do
        before do
          parsed_csv = generate_parsed_csv_with_user(user: user, allocation_amount: 420)
          AllocationService.create_allocations_from_csv(parsed_csv: parsed_csv, group: group, current_user: current_user)
        end

        it "user receives 'invite to group' email" do
          sent_email = ActionMailer::Base.deliveries.first
          expect(sent_email.body.to_s).to include("#{current_user.name} has invited you to collaboratively budget with everyone else at #{group.name}. You've got $420.00 to spend!".html_safe)
        end

        it "membership created for user" do
          expect(Membership.find_by(member: user, group: group)).to be_truthy
        end

        it "user receives allocation" do
          expect(Allocation.find_by(user: user, amount: 420, group: group)).to be_truthy
        end
      end
    end

    context "user doesn't exist" do
      before do
        parsed_csv = [["fucking_doge_hat@com.com", 420]]
        AllocationService.create_allocations_from_csv(parsed_csv: parsed_csv, group: group, current_user: current_user)
        @new_user = User.find_by_email("fucking_doge_hat@com.com")
      end

      it "new_user created" do
        expect(@new_user).to be_truthy
      end

      it "membership created" do
        expect(Membership.find_by(member: @new_user, group: group)).to be_truthy
      end

      it "new_user receives 'invite to cobudget' email" do
        sent_email = ActionMailer::Base.deliveries.first
        expect(sent_email.body.to_s).to include("You have been invited by #{current_user.name} to collaboratively fund with #{group.name} on Cobudget. You've got $420.00 to spend!")
      end

      it "new_user receives allocation" do
        expect(Allocation.find_by(user: @new_user, group: group, amount: 420)).to be_truthy
      end
    end

    context "properly formatted csv" do
      it "returns true" do
        parsed_csv = [["fucking_doge_hat@com.com", 420]]
        result = AllocationService.create_allocations_from_csv(parsed_csv: parsed_csv, group: group, current_user: current_user)
        expect(result).to be_truthy
      end
    end

    context "fucked up csv" do
      before do
        parsed_csv = [["fucking_doge_hat@com.com", 420], [], ['lol']]
        @result = AllocationService.create_allocations_from_csv(parsed_csv: parsed_csv, group: group, current_user: current_user)
      end

      it "sends no emails" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "creates no records" do
        expect(User.find_by_email("fucking_doge_hat@com.com")).to be_nil
        expect(Membership.count).to eq(0)
        expect(Allocation.count).to eq(0)
      end

      it "returns false" do
        expect(@result).to be_falsey
      end
    end
  end
end
