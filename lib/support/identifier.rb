require 'cobudget/entities/transaction'

module Cobudget
  class Identifier
    def self.generate
      max = Transaction.maximum("identifier").to_i
      max ||= 1
      self.identifier = max + 1
    end
  end
end

