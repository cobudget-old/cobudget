require "rails_helper"

describe "AllocationService" do
  after do
    ActionMailer::Base.deliveries.clear
  end

  describe "#create_allocations_from_csv(csv: , group: , current_user:)" do
    before do
      @group = create(:group)
      @admin_user = create(:user)
      @admin_membership = create(:membership, member: @admin_user, group: @group, is_admin: true)
      @bucket = create(:bucket, user: @admin_user, group: @group, status: "live")

      @user = create(:user)
      @membership = create(:membership, member: @user, group: @group)

      # create an archived participant
      @archived_participant = create_bucket_participant(bucket: @bucket, subscribed: true)
      Membership.find_by(group: @bucket.group, member: @archived_participant).update(archived_at: DateTime.now.utc - 5.days)

      @archived_participant2 = create_bucket_participant(bucket: @bucket, subscribed: true)
      Membership.find_by(group: @bucket.group, member: @archived_participant2).update(archived_at: DateTime.now.utc - 5.days)

    end

    it "uploads new allocations via csv" do
      csv = CSV.read("./spec/fixtures/test-csv.csv")

      AllocationService.create_allocations_from_csv(csv: csv, group: @group, current_user: @admin_user)
      kat = User.find_by(email: "katrine_ebert@hermann.net")
      expect(kat).to be_truthy
      expect(@group.memberships.find_by(member: kat)).to be_truthy
    end

    it "returns errors when csv contains archived member(s)" do
      csv = CSV.read("./spec/fixtures/test-csv.csv")
      
      csv << [@archived_participant[:email], "9000"]
      csv << [@archived_participant2[:email], "9000"]
      csv << ["gbickford@gmail.com", "9000"]

      errors = []
      ActiveRecord::Base.transaction do
        errors = AllocationService.create_allocations_from_csv(csv: csv, group: @group, current_user: @admin_user)
        expect(errors).not_to be_empty
        if errors
          raise ActiveRecord::Rollback
        end
      end
      gardner_user = User.find_by(email: "gbickford@gmail.com")
      expect(gardner_user).not_to be_truthy

      archived_user = User.find_by(email: @archived_participant[:email])
      expect(archived_user).to be_truthy

      errors
    end

  end
end
