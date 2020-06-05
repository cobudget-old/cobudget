class UserSerializer < ActiveModel::Serializer
  # embed :ids, include: true
  attributes :id,
             :name,
             :email,
             :utc_offset,
             :confirmed_at,
             :joined_first_group_at,
             :is_super_admin,
             :current_sign_in_at,
             :updated_at

  has_one :subscription_tracker
end
