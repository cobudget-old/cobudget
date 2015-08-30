class BucketSerializer < ActiveModel::Serializer
  embed :ids, include: true
  has_one :user
  has_one :group
  attributes :id,
             :name,
             :target,
             :description,
             :created_at,
             :status,
             :total_contributions,
             :num_of_contributors,
             :funding_closes_at,
             :funded_at,
             :live_at
end