require 'spec_helper'
require 'cobudget/contexts/bucket_allocations_from_user_enquiry'

module Cobudget
  describe BucketAllocationsFromUserEnquiry do
    let(:bucket) {FactoryGirl.create(:bucket)}
    subject { BucketAllocationsFromUserEnquiry.new(bucket: bucket, user: User.new) }

    it 'returns a money object with the bucket balance' do
      subject.bucket.stub(:balance_from_user).and_return(15)
      expect(subject.call).to eq(Money.new(15))
    end
  end
end
