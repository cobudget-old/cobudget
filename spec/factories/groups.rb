FactoryGirl.define do
  factory :group do
    name { Faker::Company.name }
    initialized { true }
  end
end
