module Helpers
  def parsed(response)
    JSON.parse(response.body)
  end

  def membership_with_balance(balance:, member: nil, group: nil)
    member = member || create(:user)
    group = group || create(:group)
    membership = create(:membership, member: member, group: group)
    create(:allocation, user: member, group: group, amount: balance)
    membership
  end

  def create_bucket_participant(bucket:, subscribed:, type: :commenter)
    participant = create(:user, subscribed_to_participant_activity: subscribed)
    create(:membership, member: participant, group: bucket.group)
    case type
      when :commenter then create(:comment, bucket: bucket, user: participant)
      when :funder
        create(:allocation, group: bucket.group, user: participant, amount: 1)
        create(:contribution, bucket: bucket, user: participant)
    end
    participant
  end
end
