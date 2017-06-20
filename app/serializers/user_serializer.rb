class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id,
             :name,
             :email,
             :utc_offset,
             :confirmed_at,
             :joined_first_group_at,
             :is_super_admin

  has_one :subscription_tracker
  has_many :announcements
end
