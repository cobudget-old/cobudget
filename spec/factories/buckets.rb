FactoryGirl.define do
  factory :bucket do
    name { Faker::Company.name }
    group
    user
    target 500
  end
end
