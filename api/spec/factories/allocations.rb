FactoryGirl.define do
  factory :allocation do
    user
    group
    amount 40
    before(:create) do |allocation|
      Membership.find_or_create_by(member: allocation.user, group: allocation.group)
    end
  end
end
