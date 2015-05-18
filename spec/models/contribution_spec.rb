require 'rails_helper'

RSpec.describe Contribution, :type => :model do

	it { should have_db_column(:amount).of_type(:decimal).with_options(precision: 12, scale: 2, default: 0.0) }

  it { should belong_to(:bucket) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:bucket_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:bucket_id) }
  it { should validate_numericality_of(:amount).is_greater_than(0) }

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
