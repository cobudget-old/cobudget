FactoryGirl.define do
  factory :bucket do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    group
    user
    target 500
    status 'draft'

    after(:create) do |bucket|
      group = bucket.group
      author = bucket.user
      group.add_member(author) unless author.is_member_of?(group)
    end
  end
end
