class AllocationSerializer < ActiveModel::Serializer
  attributes :amount_cents, :round_id
  has_one :user
end
