module Cobudget
  class MoneyComposer
    def self.compose(amount)
      Money.new(amount.to_f)
    end
  end
end