require 'money'

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
        puts money.inspect
        if money.nil?
          write_attribute(numeric_field, nil)
        else
          #write_attribute(numeric_field, nil)
          #######CENTS DOESNT EXIST####
          write_attribute(numeric_field, money.cents)
        end
      end
    end
  end
end
