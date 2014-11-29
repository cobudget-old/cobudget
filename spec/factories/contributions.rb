FactoryGirl.define do
  factory :contribution do
    user
    bucket
    amount_cents 100
  end
end
