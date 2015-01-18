class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :member, class_name: "User"

  validates :group_id, presence: true
  validates :member_id, presence: true, uniqueness: { scope: :group_id }
end
