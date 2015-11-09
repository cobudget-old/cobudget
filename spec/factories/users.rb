FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password 'password'
    initialized true
    subscribed_to_personal_activity true
    subscribed_to_daily_digest true
  end
end