require 'money'
#require 'money/core_extensions' #this does not get rid of those depracation warnings...

module MoneyAttribute
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def money_attribute attr_name
      numeric_field = "#{attr_name}_cents".to_sym

      define_method attr_name do
        Money.new(read_attribute(numeric_field)) if read_attribute(numeric_field)
      end

      define_method "#{attr_name}=" do |money|
        if money.nil?
          write_attribute(numeric_field, nil)
        else
          mny = Money.new(money * 100)
          write_attribute(numeric_field, mny.cents)
        end
      end
    end
  end
end
