class BudgetSerializer < ActiveModel::Serializer
  attributes :id, :name, :latest_round_id
end
