require 'rails_helper'

RSpec.describe FixedCost, :type => :model do

	describe "fields" do
		it { should have_db_column(:name) }
		it { should have_db_column(:description) }
		it { should have_db_column(:amount).with_options(precision: 12, scale: 2, default: 0.0) }
	end

	describe "associations" do
		it { should belong_to(:round) }
	end

	describe "validations" do
		it { should validate_presence_of(:name) }
		it { should validate_presence_of(:round_id) }
		it { should validate_presence_of(:amount) }
	end

end
