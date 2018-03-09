FactoryGirl.define do
  factory :transaction do
    datetime DateTime.now.utc
    amount 10
  end
end
