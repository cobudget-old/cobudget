require 'rails_helper'

RSpec.describe Contribution, :type => :model do
  describe "#reset_amount_if_exceeds_target" do
    it "changes amount to exactly reach target, if initial amount exceeds it" do
      bucket = create(:bucket, group: group, target: 500)
      make_user_group_member
      create(:contribution, amount: 200, user: user, bucket: bucket)
      contribution = create(:contribution, amount: 600, user: user, bucket: bucket)

      bucket.reload
      contribution.reload

      expect(bucket.total_contributions).to eq(500)
      expect(contribution.amount).to eq(300)
    end
  end
end