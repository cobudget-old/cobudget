class FullAllocatorSerializer < ActiveModel::Serializer
  attributes :id, :name, :allocation_rights_total_cents
  has_many :allocation_rights
end
