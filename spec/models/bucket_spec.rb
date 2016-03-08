require 'rails_helper'

RSpec.describe Bucket, :type => :model do
  describe "#total_contributions" do
    context "if contributions" do
      it "returns the sum of contribution amounts for bucket" do
        bucket = create(:bucket, target: 1000)
        create(:contribution, bucket: bucket, amount: 100)
        create(:contribution, bucket: bucket, amount: 220)
        create(:contribution, bucket: bucket, amount: 40)
        expect(bucket.total_contributions).to eq(360)
      end
    end

    context "if no contributions" do
      it "returns 0" do
        bucket = create(:bucket)
        expect(bucket.total_contributions).to eq(0)
      end
    end
  end

  describe "num_of_contributors" do
    it "returns the number of contributions with unique user_id" do
      bucket = create(:bucket)
      user1 = create(:user)
      user2 = create(:user)
      create(:contribution, bucket: bucket, user: user1)
      create(:contribution, bucket: bucket, user: user1)
      create(:contribution, bucket: bucket, user: user2)
      expect(bucket.num_of_contributors).to eq(2)
    end
  end

  describe "#set_timestamp_if_status_updated" do
    context "status updated to 'live'" do
      it "sets live_at" do
        bucket.update(status: 'live')
        expect(bucket.live_at).to be_truthy
      end
    end

    context "status updated to 'funded'" do
      it "sets funded_at" do
        bucket.update(status: 'funded')
        expect(bucket.funded_at).to be_truthy
      end
    end
  end

  describe "#formatted_percent_funded" do
    it "returns percent that the bucket has been funded, with no decimal places" do
      bucket = create(:bucket, status: 'live', target: 100)
      expect(bucket.formatted_percent_funded).to eq("0%")
      create(:contribution, bucket: bucket, amount: 22)
      expect(bucket.formatted_percent_funded).to eq("22%")
    end
  end
end
