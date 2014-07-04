require 'spec_helper'
require 'cobudget/contexts/bucket_balance_enquiry'

module Cobudget
  describe BucketBalanceEnquiry do
    subject { BucketBalanceEnquiry.new(bucket: Bucket.new) }

    it 'returns a money object with the bucket balance' do
      subject.bucket.stub(:balance).and_return(10)
      expect(subject.call).to eq(Money.new(10))
    end
  end
end
