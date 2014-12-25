class MembershipPolicy < ApplicationPolicy
  def create?
    user.is_admin_for?(record.group)
  end

  def update?
    user.is_admin_for?(record.group)
  end

  def destroy?
    (record.user_id == user.id) || user.is_admin_for?(record.group)
  end
end
