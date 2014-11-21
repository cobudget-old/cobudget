FactoryGirl.define do
  factory :round do
    name { Faker::Company.name }
    group
  end
end
