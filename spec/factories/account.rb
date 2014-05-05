require 'cobudget/entities/account'

FactoryGirl.define do
  factory :account, class: Cobudget::Account do
    budget
  end
end
