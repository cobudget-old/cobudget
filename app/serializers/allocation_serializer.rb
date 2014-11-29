class AllocationSerializer < ActiveModel::Serializer
  attributes :amount_cents, :round_id, :user_id
end
