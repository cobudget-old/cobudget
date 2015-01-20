class RoundShortSerializer < ActiveModel::Serializer
  attributes :id, :name, :starts_at, :ends_at, :members_can_propose_buckets
end
