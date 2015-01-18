class MembershipSerializer < ActiveModel::Serializer
  attributes :id, :group_id, :is_admin, :created_at
  has_one :member
end
