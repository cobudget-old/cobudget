class ContributionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :created_at
  has_one :user
end
