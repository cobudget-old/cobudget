class GroupSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id,
             :name,
             :balance,
             :currency_symbol,
             :currency_code,
             :is_launched,
             :plan,
             :trial_end,
             :total_contributions
end
