class FullBudgetSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :latest_round
end
