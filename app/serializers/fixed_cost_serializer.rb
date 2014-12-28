class FixedCostSerializer < ActiveModel::Serializer
  attributes :id, :round_id, :name, :amount, :description
end
