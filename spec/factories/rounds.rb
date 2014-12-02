FactoryGirl.define do
  factory :round do
    name { Faker::Company.name }
    group
    starts_at Time.zone.now
    ends_at Time.zone.now + 3.days
  end
end
