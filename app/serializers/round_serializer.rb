class RoundSerializer < ActiveModel::Serializer
  attributes :id, :name, :group_id
  has_many :buckets
  has_many :allocations
end
