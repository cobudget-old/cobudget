class AllocationSerializer < ActiveModel::Serializer
  # embed :ids, include: true
  attributes :id,
             :amount,
             :group_id,
             :user_id, 
             :created_at
  has_one :user
  has_one :group
end
