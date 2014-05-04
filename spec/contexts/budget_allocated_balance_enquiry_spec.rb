require 'spec_helper'
require 'cobudget/contexts/budget_allocated_balance_enquiry'

module Cobudget
  describe BudgetAllocatedBalanceEnquiry do
    subject { BudgetAllocatedBalanceEnquiry.new(budget: Budget.new) }

    it 'returns a money object with the bucket balance' do
      subject.budget.stub(:total_allocated).and_return(20)
      expect(subject.call).to eq(Money.new(20))
    end
  end
end
