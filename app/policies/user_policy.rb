class UserPolicy < ApplicationPolicy
  def update?
    user == record
  end

  def change_password?
    user == record
  end
end
