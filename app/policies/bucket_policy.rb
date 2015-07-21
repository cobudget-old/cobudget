class BucketPolicy < ApplicationPolicy
  def create?
    user.is_member_of?(record.group)
  end

  def update?
    user.is_member_of?(record.group) && (record.user == user || user.is_admin_for?(record.group))
  end

  def destroy?
    user.is_member_of?(record.group) && (record.user == user || user.is_admin_for?(record.group))
  end
end
