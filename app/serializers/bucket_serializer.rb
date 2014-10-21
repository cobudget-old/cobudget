class BucketSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :contribution_total_cents,
             :target_cents,
             :percentage_funded,
             :description,
             :contributions

  has_many :contributions
  has_one :user
end
