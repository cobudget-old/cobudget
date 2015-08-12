class MembershipSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :is_admin, :created_at, :total_allocations, :total_contributions

  has_one :member, serializer: UserSerializer, root: 'users'
  has_one :group, serializer: GroupSerializer, root: 'groups'
end