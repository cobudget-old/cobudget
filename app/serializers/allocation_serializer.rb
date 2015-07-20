class AllocationSerializer < ActiveModel::Serializer
  attributes :id, :amount, :group_id, :user_id
end
