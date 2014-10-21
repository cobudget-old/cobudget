class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :latest_round_id
  has_one :latest_round
end
