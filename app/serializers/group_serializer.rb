class GroupSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id,
             :name,
             :balance,
             :currency_symbol,
             :currency_code,
             :description,
             :is_launched,
             :plan,
             :trial_end,
             :total_in_circulation,
             :ready_to_pay_total,
             :total_allocations,
             :total_contributions,
             :group_account_balance,
             :total_in_unfunded,
             :funding_freeze
end
