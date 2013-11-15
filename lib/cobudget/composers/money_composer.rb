module Cobudget
  class MoneyComposer
    def compose(attributes)
      Money.new(attributes['amount'])
    end
  end
end