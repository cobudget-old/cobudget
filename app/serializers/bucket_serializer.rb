class BucketSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id,
             :group_id,
             :name,
             :target,
             :description,
             :created_at,
             :total_contributions
end
