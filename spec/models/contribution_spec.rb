require 'rails_helper'

RSpec.describe Contribution, :type => :model do
  describe "#lower_amount_if_exceeds_target" do
    it "changes amount to exactly reach target, if initial amount exceeds it" do
      bucket = create(:bucket, group: group, target: 500)
      make_user_group_member
      contribution1 = create(:contribution, amount: 200, user: user, bucket: bucket)
      contribution2 = create(:contribution, amount: 600, user: user, bucket: bucket)
      contribution3 = create(:contribution, amount: 600, user: user, bucket: bucket)


      bucket.reload
      contribution1.reload
      contribution2.reload
      contribution3.reload

      expect(bucket.total_contributions).to eq(500)
      expect(contribution1.amount).to eq(200)
      expect(contribution2.amount).to eq(300)
      expect(contribution3.amount).to eq(0)
    end
  end
end