require 'rails_helper'

RSpec.describe Round, :type => :model do

  describe "fields" do
    it { should have_db_column(:group_id).with_options(null: false) }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:starts_at).of_type(:datetime) }
    it { should have_db_column(:ends_at).of_type(:datetime) }
    it { should have_db_column(:members_can_propose_buckets).of_type(:boolean) }
  end

  describe "associations" do
    it { should belong_to(:group) }
    it { should have_many(:buckets).dependent(:destroy) }
    it { should have_many(:allocations).dependent(:destroy) }
    it { should have_many(:fixed_costs).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:group) }
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

  describe '#open_for_proposals?' do
    it "returns true if starts_at and ends_at are defined and starts_at hasn't happened yet" do
      expect(create(:round).open_for_proposals?).to be false
      expect(create(:round_open_for_proposals).open_for_proposals?).to be true
      expect(create(:round_open_for_contributions).open_for_proposals?).to be false
      expect(create(:round_closed).open_for_proposals?).to be false
    end
  end

  describe '#closed?' do
    it "returns true if ends_at has already happened" do
      expect(create(:round_open_for_contributions).closed?).to be false
      expect(create(:round_closed).closed?).to be true
    end
  end
end
