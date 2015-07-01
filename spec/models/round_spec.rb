require 'rails_helper'

RSpec.describe Round, :type => :model do

  describe "fields" do
    it { should have_db_column(:group_id).with_options(null: false) }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:starts_at).of_type(:datetime) }
    it { should have_db_column(:ends_at).of_type(:datetime) }
    it { should have_db_column(:members_can_propose_buckets).of_type(:boolean) }
    it { should have_db_column(:published).of_type(:boolean).with_options(default: false)}
  end

  describe "associations" do
    it { should belong_to(:group) }
    it { should have_many(:buckets).dependent(:destroy) }
    it { should have_many(:allocations).dependent(:destroy) }
    it { should have_many(:fixed_costs).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:group) }
  end

  describe "#generate_new_members_and_allocations_from(csv, current_user)" do

    before do
      @csv = CSV.read('./spec/assets/test-csv.csv')
      @group = create(:group)
      @admin = create(:user)
      @group.add_admin(@admin)
      @csv.each { |email, allocation| @group.members << create(:user, email: email) }
      @round = create(:round, group: @group)
    end

    it "generates allocations for round from a 2-column csv file containing emails and allocations" do
      @round.generate_new_members_and_allocations_from!(@csv, @admin)
      @csv.each do |email, allocation|
        user_id = User.find_by_email(email).id
        expect(@round.allocations.find_by(user_id: user_id, amount: allocation.to_i)).to be_truthy
      end
    end

    context "if any cobudget users in csv not already a member of group" do
      before do
        @new_member = @group.members.last
        @group.members.delete(@new_member.id)
        @group.reload
      end

      it "should add them to the group" do
        @round.generate_new_members_and_allocations_from!(@csv, @admin)
        expect(@group.members).to include(@new_member)
      end

      it "should send them an 'invite to group' email" do
        mail_double = double('mail')
        expect(UserMailer).to receive(:invite_to_group_email).with(@new_member, @admin, @group, @round).and_return(mail_double)
        expect(mail_double).to receive(:deliver!)
        @round.generate_new_members_and_allocations_from!(@csv, @admin)
      end

      it "should generate allocation for the new group member" do
        @round.generate_new_members_and_allocations_from!(@csv, @admin)
        expect(@round.allocations.find_by(user_id: @new_member.id)).to be_truthy
      end
    end
  
    context "if any users in csv not a part of cobudget at all" do
      before do
        @new_member = @group.members.last.delete
      end

      it "should add them to cobudget" do
        @round.generate_new_members_and_allocations_from!(@csv, @admin)
        expect(User.find_by_email(@new_member.email)).to be_truthy
      end

      it "should add them to the group" do
        @round.generate_new_members_and_allocations_from!(@csv, @admin)
        expect(@group.members.find_by_email(@new_member.email)).to be_truthy
      end

      it "should send them an invite to cobudget email" do
        mail_double = double('mail')
        expect(UserMailer).to receive(:invite_to_group_email).and_return(mail_double)
        expect(mail_double).to receive(:deliver!)
        @round.generate_new_members_and_allocations_from!(@csv, @admin)
      end

      it "should send them an invite to group email" do
        mail_double = double('mail')
        expect(UserMailer).to receive(:invite_email).and_return(mail_double)
        expect(mail_double).to receive(:deliver!)
        @round.generate_new_members_and_allocations_from!(@csv, @admin)
      end

      it "should generate allocation for new cobudgeter" do
        @round.generate_new_members_and_allocations_from!(@csv, @admin)
        expect(@round.allocations.find_by(user: User.find_by_email(@new_member.email))).to be_truthy
      end
    end
  end

  describe "#mode" do
    it "if unpublished -- draft mode" do
      expect(create(:draft_round).mode).to eq("draft")
    end
    it "if published, and starts_at set but not reached -- proposal mode" do
      expect(create(:round_open_for_proposals).mode).to eq("proposal")
    end
    it "if published, and current time is between starts_at and ends_at -- contribution mode" do
      expect(create(:round_open_for_contributions).mode).to eq("contribution")
    end
    it "if published, and current time is after ends_at -- closed mode" do
      expect(create(:round_closed).mode).to eq("closed")
    end
  end

  describe "#publish!" do

    it "updates published to true" do
      round = create(:draft_round)
      round.publish!
      expect(round.published).to eq(true)
    end

    xit "send notification emails to everyone involved in the round" do
    end

  end

  describe "#start_and_end_go_together" do
    it "validates that both starts_at and ends_at to be present or neither be present" do
      expect { Round.create!(name: 'hi', group: group) }.not_to raise_error
      expect { Round.create!(name: 'hi', group: group, starts_at: Time.now + 1.day, ends_at: Time.now + 3.days) }.not_to raise_error
      expect { Round.create!(name: 'hi', group: group, starts_at: Time.now + 1.day) }.to raise_error 
      expect { Round.create!(name: 'hi', group: group, ends_at: Time.now + 1.day) }.to raise_error
    end
  end

  describe "#starts_at_before_ends_at" do
    it 'validates that starts_at is before ends_at' do
      expect { Round.create!(name: 'hi', group: group, starts_at: Time.now + 2.days, ends_at: Time.now + 1.day) }.to raise_error
    end    
  end

end
