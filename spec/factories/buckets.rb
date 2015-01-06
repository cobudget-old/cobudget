FactoryGirl.define do
  factory :bucket do
    name { Faker::Company.name }
    round
    user
    target 500
  end
end
