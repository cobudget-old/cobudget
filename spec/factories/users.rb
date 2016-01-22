FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password 'password'
    subscribed_to_personal_activity true
    subscribed_to_daily_digest true
    subscribed_to_participant_activity false
    confirmed_at Time.now.utc
  end
end
