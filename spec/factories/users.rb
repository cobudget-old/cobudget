FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password 'password'
    confirmed_at Time.now.utc

    after(:create) do |user|
      if user.confirmed?
        user.subscription_tracker.update(notification_frequency: "hourly")
      end
    end
  end
end
