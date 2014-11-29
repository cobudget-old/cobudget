class RoundShortSerializer < ActiveModel::Serializer
  attributes :id, :name, :starts_at, :ends_at
end
