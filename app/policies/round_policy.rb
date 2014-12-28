class RoundPolicy < ApplicationPolicy
  def create?
    user.is_admin_for?(record.group)
  end
end
