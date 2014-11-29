class AllocationSerializer < ActiveModel::Serializer
  attributes :id, :amount_cents, :round_id, :user_id
end
