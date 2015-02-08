class BucketSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :target,
             :description

  has_many :contributions
  has_one :user
end
