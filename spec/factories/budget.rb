require 'cobudget/entities/budget'
FactoryGirl.define do
  factory :budget, class: Cobudget::Budget do
    name 'Budget'
  end
end