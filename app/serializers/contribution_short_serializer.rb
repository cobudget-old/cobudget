class ContributionShortSerializer < ActiveModel::Serializer
  attributes :id, :amount_cents, :user_id
end
