require 'rails_helper'

RSpec.describe Membership, :type => :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  it "allows only one membership per user per group" do
    expect { Membership.create!(user: user, group: group) }.not_to raise_error
    expect { Membership.create!(user: user, group: group) }.to raise_error
  end
end
