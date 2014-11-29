FactoryGirl.define do
  factory :bucket do
    name { Faker::Company.name }
    round
    user
    target_cents 50000
  end
end
