FactoryGirl.define do
  factory :membership do
    group
    association :member, factory: :user
  end
end
