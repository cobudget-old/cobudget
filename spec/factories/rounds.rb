FactoryGirl.define do
  factory :round do
    name { Faker::Company.name }
    group
    members_can_propose_buckets true
  end

  factory :round_open_for_proposals, class: :round do
    name { Faker::Company.name }
    group
    members_can_propose_buckets true
    starts_at Time.zone.now + 1.days
    ends_at Time.zone.now + 3.days
  end

  factory :round_open_for_contributions, class: :round do
    name { Faker::Company.name }
    group
    members_can_propose_buckets true
    starts_at Time.zone.now - 2.days
    ends_at Time.zone.now + 2.days
  end

  factory :round_closed, class: :round do
    name { Faker::Company.name }
    group
    members_can_propose_buckets true
    starts_at Time.zone.now - 5.days
    ends_at Time.zone.now - 2.days
  end
end
