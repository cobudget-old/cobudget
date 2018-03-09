class CommentSerializer < ActiveModel::Serializer
  embed :ids, include: true
  has_one :user
  attributes :id,
             :bucket_id,
             :user_id,
             :body,
             :created_at,
             :updated_at,
             :author_name
end
