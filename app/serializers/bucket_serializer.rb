class BucketSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :contribution_total,
             :target,
             :percentage_funded,
             :description

  has_many :contributions
  has_one :user
end
