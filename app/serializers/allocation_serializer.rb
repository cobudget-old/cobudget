class AllocationSerializer < ActiveModel::Serializer
  attributes :id, :amount, :round_id, :user_id
end
