require 'spec_helper'
require 'cobudget/contexts/budget_unallocated_balance_enquiry'

module Cobudget
  describe BudgetUnallocatedBalanceEnquiry do
    subject { BudgetUnallocatedBalanceEnquiry.new(budget: Budget.new) }

    it 'returns a money object with the bucket balance' do
      subject.budget.stub(:total_available_for_allocation).and_return(20)
      expect(subject.call).to eq(Money.new(20))
    end
  end
end
