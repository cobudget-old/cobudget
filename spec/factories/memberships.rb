FactoryGirl.define do
  factory :membership do
    group
    user
    is_admin false
  end
end
