FactoryGirl.define do

  factory :bucket do
    name { Faker::Company.name }
    group
    user
    target 500
    status 'live'
  end

  factory :live_bucket, class: Bucket do
    name { Faker::Company.name }
    group
    user
    target 500
    status 'live'
  end

  factory :draft_bucket, class: Bucket do
    name { Faker::Company.name }
    group
    user
    status 'draft'
  end
end
