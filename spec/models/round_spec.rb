require 'rails_helper'

RSpec.describe Round, :type => :model do
  it "starts_at and ends_at must both be present or neither be present" do
    expect { Round.create!(name: 'hi', group: group) }.not_to raise_error
    expect { Round.create!(name: 'hi', group: group,
             starts_at: Time.now + 1.day,
             ends_at: Time.now + 3.days) }.not_to raise_error

    expect { Round.create!(name: 'hi', group: group,
             starts_at: Time.now + 1.day) }.to raise_error
    expect { Round.create!(name: 'hi', group: group,
             ends_at: Time.now + 1.day) }.to raise_error
  end

  it 'starts_at must be before ends_at' do
    expect { Round.create!(name: 'hi', group: group,
             starts_at: Time.now + 2.days,
             ends_at: Time.now + 1.day) }.to raise_error
  end

  context '#open_for_proposals?' do
    it "returns true if starts_at and ends_at are defined and starts_at hasn't happened yet" do
      expect(FactoryGirl.create(:round).open_for_proposals?).to be false
      expect(FactoryGirl.create(:round_open_for_proposals).
        open_for_proposals?).to be true
      expect(FactoryGirl.create(:round_open_for_contributions).
        open_for_proposals?).to be false
      expect(FactoryGirl.create(:round_closed).
        open_for_proposals?).to be false
    end
  end

  context '#closed?' do
    it "returns true if ends_at has already happened" do
      expect(FactoryGirl.create(:round_open_for_contributions).
        closed?).to be false
      expect(FactoryGirl.create(:round_closed).closed?).to be true
    end
  end
end
