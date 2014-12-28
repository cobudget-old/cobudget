require 'rails_helper'

RSpec.describe Contribution, :type => :model do
  let(:contribution) { FactoryGirl.create(:contribution) }

  it "validates that allocation is greater than 0" do
    contribution.amount = BigDecimal.new(0)
    expect(contribution).to_not be_valid
  end
end
