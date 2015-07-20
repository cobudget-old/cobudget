require 'rails_helper'

RSpec.describe Allocation, :type => :model do
	describe "#formatted_amount" do
		it "returns allocation amount, round to two decimal places with $ in front" do
			allocation = create(:allocation, amount: 234.50)
			expect(allocation.formatted_amount).to eq("$234.50")
		end
	end
end