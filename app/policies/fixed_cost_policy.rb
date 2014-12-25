class FixedCostPolicy < ApplicationPolicy
  def create?
    user_is_admin?
  end

  def update?
    user_is_admin?
  end

  def destroy?
    user_is_admin?
  end

  private
    def user_is_admin?
      user.is_admin_for?(record.round.group)
    end
end
