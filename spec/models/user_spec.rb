require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:membership) { FactoryGirl.create(:membership, member: user) }
  let(:admin_membership) { FactoryGirl.create(:membership, member: user, is_admin: true) }

  it { expect(user.is_admin_for?(membership.group)).to eq false }
  it { expect(user.is_admin_for?(admin_membership.group)).to eq true }
end
