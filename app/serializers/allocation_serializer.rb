class AllocationSerializer < ActiveModel::Serializer
  attributes :amount_cents, :person_id, :round_id
end
