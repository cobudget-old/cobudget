require 'rails_helper'

RSpec.describe Bucket, :type => :model do
  describe "#total_contributions" do
    it "returns the sum of contribution amounts for bucket" do
      create(:contribution, bucket: bucket, amount: 100)
      create(:contribution, bucket: bucket, amount: 220)
      create(:contribution, bucket: bucket, amount: 40)
      expect(bucket.total_contributions).to eq(360)
    end
  end

  describe "#publish(target)!" do
    before do
      @bucket = create(:draft_bucket)
      @bucket.publish!(10000)
    end

    it "sets 'published' to 'true'" do
      expect(@bucket.published).to eq(true)
    end

    it "sets target" do
      expect(@bucket.target).to eq(10000)
    end
  end
end