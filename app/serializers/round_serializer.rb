class RoundSerializer < ActiveModel::Serializer
  attributes :id
  has_one :budget
  has_many :round_projects, serializer: FullRoundProjectSerializer
end
