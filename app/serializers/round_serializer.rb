class RoundSerializer < ActiveModel::Serializer
  attributes :id, :name, :group_id, :starts_at, :ends_at
  has_many :buckets
  has_many :allocations

  # def allocations
  #   object.allocations.map do |allocation|
  #     AllocationSerializer.new(allocation)
  #   end
  # end
end
