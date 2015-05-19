require 'rails_helper'

RSpec.describe Membership, :type => :model do

  describe "fields" do
    it { should have_db_column(:group_id).with_options(null: false) }
    it { should have_db_column(:member_id).with_options(null: false) }
    it { should have_db_column(:is_admin).with_options(default: false, null: false) }
  end

  describe "associations" do
    it { should belong_to(:group) }
    it { should belong_to(:member).class_name("User") }
  end

  describe "validations" do
    it { should validate_presence_of(:group_id) }
    it { should validate_presence_of(:member_id) }
    it "allows only one membership per user per group" do
      expect(create(:membership)).to validate_uniqueness_of(:member_id).scoped_to(:group_id)
    end
  end

end
