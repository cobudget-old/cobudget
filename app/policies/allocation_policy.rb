class AllocationPolicy < ApplicationPolicy
  def create?
    user.is_admin_for?(record.group)
  end

  def update?
    user.is_admin_for?(record.group)
  end
end
