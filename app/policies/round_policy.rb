class RoundPolicy < ApplicationPolicy
  def create?
    user.is_admin_for?(record.group)
  end

  def destroy?
    user.is_admin_for?(record.group)
  end

  def update?
    user.is_admin_for?(record.group)
  end

  def upload?
    user.is_admin_for?(record.group)
  end

  def open_for_proposals?
    user.is_admin_for?(record.group)
  end

  def open_for_contributions?
    user.is_admin_for?(record.group)
  end
end
