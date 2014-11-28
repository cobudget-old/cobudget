class MembershipSerializer < ActiveModel::Serializer
  attributes :id, :group_id
  has_one :user
end
