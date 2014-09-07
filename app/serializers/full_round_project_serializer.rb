class FullRoundProjectSerializer < ActiveModel::Serializer
  #attributes :id
  has_one :project, serializer: FullProjectSerializer
end
