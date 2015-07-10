require 'rails_helper'

RSpec.describe Round, :type => :model do
  describe "#mode" do
    it "if unpublished -- draft mode" do
      expect(create(:draft_round).mode).to eq("draft")
    end

    it "if published, and starts_at set but not reached -- proposal mode" do
      expect(create(:round_open_for_proposals).mode).to eq("proposal")
    end

    it "if published, and current time is between starts_at and ends_at -- contribution mode" do
      expect(create(:round_open_for_contributions).mode).to eq("contribution")
    end
    
    it "if published, and current time is after ends_at -- closed mode" do
      expect(create(:round_closed).mode).to eq("closed")
    end
  end

  describe "#published?" do
    it "returns true if starts_at and ends_at are both present" do
      expect(create(:round_open_for_proposals).published?).to eq(true)
    end

    it "returns false otherwise" do
      expect(create(:draft_round).published?).to eq(false)
    end
  end

  describe "has_valid_duration?" do
    it "returns true if starts_at and ends_at are present, and starts_at is before ends_at" do
      expect(create(:round_open_for_proposals).has_valid_duration?).to eq(true)
    end

    it "otherwise, returns false" do
      expect(create(:draft_round).has_valid_duration?).to eq(false)
    end
  end

  describe "#start_and_end_go_together" do
    it "validates that both starts_at and ends_at to be present or neither be present" do
      expect { Round.create!(name: 'hi', group: group) }.not_to raise_error
      expect { Round.create!(name: 'hi', group: group, starts_at: Time.now + 1.day, ends_at: Time.now + 3.days) }.not_to raise_error
      expect { Round.create!(name: 'hi', group: group, starts_at: Time.now + 1.day) }.to raise_error 
      expect { Round.create!(name: 'hi', group: group, ends_at: Time.now + 1.day) }.to raise_error
    end
  end

  describe "#starts_at_before_ends_at" do
    it 'validates that starts_at is before ends_at' do
      expect { Round.create!(name: 'hi', group: group, starts_at: Time.now + 2.days, ends_at: Time.now + 1.day) }.to raise_error
    end    
  end

  describe "#has_valid_duration_validator" do
    it "checks that a round has a valid_duration" do
      round = build(:round_open_for_proposals)
      expect(round.valid?).to eq(true)
    end

    it "adds an error if round duration not valid" do
      round = build(:draft_round)
      round.assign_attributes(starts_at: Time.zone.now, ends_at: Time.zone.now - 1.days)
      expect(round.valid?).to eq(false)
    end
  end
end