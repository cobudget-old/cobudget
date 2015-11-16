FactoryGirl.define do
  factory :bucket do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    group
    user
    target 500
    status 'live'
  end

  factory :funded_bucket, class: Bucket do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    group
    user
    target 500
    status 'funded'
  end

  factory :live_bucket, class: Bucket do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    group
    user
    target 500
    status 'live'
  end

  factory :draft_bucket, class: Bucket do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    group
    user
    status 'draft'
  end
end
