FactoryGirl.define do
  factory :comment do
    user
    bucket   
    body { Faker::Lorem.paragraph }
  end
end
