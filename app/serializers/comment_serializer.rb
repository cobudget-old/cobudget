class CommentSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id,
             :bucket_id,
             :user_id,
             :text,
             :created_at,
             :updated_at,
             :author_name
end