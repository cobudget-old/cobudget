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
end