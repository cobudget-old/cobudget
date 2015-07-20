require 'rails_helper'

RSpec.describe Contribution, :type => :model do
  describe "#self.for_round(round_id)" do
  	it "returns all contributions from buckets with specified round_id" do
  		round1 = create(:round_open_for_contributions)
  		bucket1 = create(:bucket, round: round1)	
  		contributions1 = Array.new(5) { create(:contribution, bucket: bucket1) }

  		round2 = create(:round_open_for_contributions)
  		bucket2 = create(:bucket, round: round2)	
  		contributions2 = Array.new(5) { create(:contribution, bucket: bucket2) }

  		expect(Contribution.for_round(round1.id)).to eq(contributions1)
  		expect(Contribution.for_round(round2.id)).to eq(contributions2)
  	end
  end
end