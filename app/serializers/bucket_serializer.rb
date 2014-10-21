class BucketSerializer < ActiveModel::Serializer
  attributes :id, :name, :allocation_total_cents
  has_many :allocations
end
