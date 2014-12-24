class MembershipSerializer < ActiveModel::Serializer
  attributes :id, :group_id, :is_admin
  has_one :user
end
