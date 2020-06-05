class ContributionSerializer < ActiveModel::Serializer
  embed :ids, include: true
  has_one :user
  attributes :id, 
             :bucket_id,
             :user_id,
             :amount, 
             :created_at
end
