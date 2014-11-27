class FixedCostSerializer < ActiveModel::Serializer
  attributes :id, :round_id, :name, :amount_cents, :description
end
