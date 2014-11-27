class MembershipSerializer < ActiveModel::Serializer
  attributes :id, :group_id, :user_id
  belongs_to :user
end
