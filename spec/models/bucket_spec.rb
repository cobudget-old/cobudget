require 'rails_helper'

RSpec.describe Bucket, :type => :model do

	describe "fields" do
		it { should have_db_column(:name) }
		it { should have_db_column(:description) }
		it { should have_db_column(:target).with_options(precision: 12, scale: 2, default: 0.0) }
	end

	describe "associatons" do
		it { should have_many(:contributions).order('amount DESC').dependent(:destroy) }
		it { should belong_to(:round) }
		it { should belong_to(:user) }
	end

	describe "validations" do
		it { should validate_presence_of(:name) }
		it { should validate_presence_of(:round_id) }
		it { should validate_presence_of(:user_id) }
		it { should validate_presence_of(:target) }
	end

end