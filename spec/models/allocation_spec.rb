require 'rails_helper'

RSpec.describe Allocation, :type => :model do

	describe "fields" do
		it { should have_db_column(:amount).with_options(precision: 12, scale: 2, default: 0.0)}
	end

	describe "associations" do
		it { should belong_to(:round) }
		it { should belong_to(:user) }
	end

	describe "validations" do
		it { should validate_presence_of(:round_id) }
		it { should validate_presence_of(:user_id) }
		it "allows only one allocation per user per round" do
			expect(create(:allocation)).to validate_uniqueness_of(:user_id).scoped_to(:round_id)
		end
		it { should validate_presence_of(:amount) }
	end
	
end
