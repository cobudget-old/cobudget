class AllocationSerializer < ActiveModel::Serializer
  attributes :amount_cents, :created_at, :updated_at
  has_one :allocator
end
