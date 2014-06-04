require 'cobudget/entities/user'

FactoryGirl.define do
  factory :user, class: Cobudget::User do
    email {Faker::Internet.email}
  end
end
