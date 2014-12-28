class ContributionPolicy < ApplicationPolicy
  def create?
    user.id == record.user.id
  end

  def update?
    user.id == record.user.id
  end

  def destroy?
    user.id == record.user.id
  end
end
