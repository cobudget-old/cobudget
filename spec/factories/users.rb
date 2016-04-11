FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password 'password'
    confirmed_at Time.now.utc

    after(:create) do |user|
      if user.confirmed?
        user.subscription_tracker.update(subscribed_to_email_notifications: true, email_digest_delivery_frequency: "weekly")
      end
    end
  end
end
