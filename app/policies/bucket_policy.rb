class BucketPolicy < ApplicationPolicy
  def create?
    user.is_admin_for?(record.round.group) or (
      record.round.group.members.include?(user) and
      record.round.members_can_propose_buckets
    )
  end

  def update?
    user.is_admin_for?(record.round.group) or
      record.user_id == user.id
  end

  def destroy?
    user.is_admin_for?(record.round.group) or
      record.user_id == user.id
  end
end
