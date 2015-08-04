class BucketSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id,
             :group_id,
             :user_id,
             :name,
             :target,
             :description,
             :created_at,
             :published,
             :total_contributions
end