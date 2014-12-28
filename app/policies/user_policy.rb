class UserPolicy < ApplicationPolicy
  def change_password?
    user == record
  end
end
