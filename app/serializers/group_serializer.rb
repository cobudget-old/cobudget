class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :rounds, serializer: RoundShortSerializer
end
