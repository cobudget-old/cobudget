class ContributionSerializer < ActiveModel::Serializer
  attributes :id, :amount_cents, :created_at
  has_one :user
end
