class MembershipSerializer < ActiveModel::Serializer
  #embed :ids, include: true
  attributes :id,
             :is_admin,
             :created_at,
             :balance,
             :archived_at,
             :raw_balance,
             :closed_admin_help_card_at,
             :closed_member_help_card_at

  has_one :member, serializer: UserSerializer, root: 'users'
  has_one :group, serializer: GroupSerializer, root: 'groups'
end
