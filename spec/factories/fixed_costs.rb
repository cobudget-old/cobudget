FactoryGirl.define do
  factory :fixed_cost do
    name { Faker::Commerce.department }
    amount_cents 50000
    round
  end
end
