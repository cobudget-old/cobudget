class MembershipSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id,
             :is_admin,
             :created_at,
             :balance,
             :archived_at,
             :raw_balance

  has_one :member, serializer: UserSerializer, root: 'users'
  has_one :group, serializer: GroupSerializer, root: 'groups'
end
