class BudgetSerializer < ActiveModel::Serializer
  attributes :id, :name, :current_round_id
end
