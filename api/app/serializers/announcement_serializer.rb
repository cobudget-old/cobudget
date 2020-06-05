class AnnouncementSerializer < ActiveModel::Serializer
  # embed :ids, include: true
  attributes :id,
             :title,
             :body,
             :url,
             :created_at,
             :seen

end
