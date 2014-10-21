class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :current_round_id
  has_one :current_round
end
