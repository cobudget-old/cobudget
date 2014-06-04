require 'spec_helper'
require 'cobudget/contexts/budget_total_enquiry'

module Cobudget
  describe BudgetTotalEnquiry do
    subject { BudgetTotalEnquiry.new(budget: Budget.new) }

    it 'returns a money object with the bucket balance' do
      subject.budget.stub(:total_in_budget).and_return(20)
      expect(subject.call).to eq(Money.new(20))
    end
  end
end
