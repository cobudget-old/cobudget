FactoryGirl.define do
  factory :contribution do
    user
    bucket
    amount 1

    before(:create) do |contribution|
      user = contribution.user
      group = contribution.bucket.group
      # if membership doesn't exist yet, create it, and make sure it has enough
      # money to make the contribution about to be created
      unless membership = Membership.find_by(member: user, group: group)
        membership = Membership.create(member: user, group: group)
        Allocation.create(user: user, group: group, amount: contribution.amount)
      end
    end
  end
end
