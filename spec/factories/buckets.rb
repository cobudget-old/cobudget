FactoryGirl.define do
  factory :bucket do
    name { Faker::Company.name }
    group
    user
    target 500
    published true
  end

  factory :draft_bucket, class: Bucket do
    name { Faker::Company.name }
    group
    user
    published false
  end
end
