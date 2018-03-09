FactoryGirl.define do
  factory :membership do
    group
    association :member, factory: :user
  end

  factory :archived_membership, class: Membership do
    group
    association :member, factory: :user
    archived_at { DateTime.now.utc - 5.days }
  end
end
