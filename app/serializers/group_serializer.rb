class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :current_round_id

  def current_round_id
    1
  end
end
