require 'rails_helper'

RSpec.describe Bucket, :type => :model do
  describe "#total_contributions" do
    it "returns the sum of contribution amounts for bucket" do
      bucket = create(:bucket, target: 1000)
      create(:contribution, bucket: bucket, amount: 100)
      create(:contribution, bucket: bucket, amount: 220)
      create(:contribution, bucket: bucket, amount: 40)
      expect(bucket.total_contributions).to eq(360)
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
end