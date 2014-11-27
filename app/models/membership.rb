class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validate :group_id, presence: true
  validate :user_id, presence: true
  validate :is_admin, presence: true
end
