require 'cobudget/entities/entry'

module Cobudget
  class Identifier
    def self.generate
      max = Entry.maximum("identifier").to_i
      max ||= 1
      max + 1
    end
  end
end

