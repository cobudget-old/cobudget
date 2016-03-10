FactoryGirl.define do
  factory :contribution do
    user
    bucket
    amount 1

    before(:create) do |contribution|
      Membership.find_or_create_by(member: contribution.user, group: contribution.bucket.group)
    end
  end
end
