FactoryGirl.define do
  factory :comment do
    user
    bucket
    body { Faker::Lorem.paragraph }

    before(:create) do |comment|
      Membership.find_or_create_by(member: comment.user, group: comment.bucket.group)
    end
  end
end
