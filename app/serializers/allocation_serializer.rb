class AllocationSerializer < ActiveModel::Serializer
  attributes :amount_cents, :round_id
  belongs_to :user
end
