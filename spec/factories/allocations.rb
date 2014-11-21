FactoryGirl.define do
  factory :allocation do
    user
    round
    amount_cents 4000
  end
end
