class FullBucketSerializer < ActiveModel::Serializer
  has_many :allocations
end
