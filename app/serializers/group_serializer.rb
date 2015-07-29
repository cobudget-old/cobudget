class GroupSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :name
  has_many :buckets
end