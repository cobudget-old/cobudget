class FullBucketSerializer < ActiveModel::Serializer
  attributes :allocation_total_cents
  has_many :allocations

end
