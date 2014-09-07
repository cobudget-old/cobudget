class FullProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :created_at, :min_cents, :target_cents, :max_cents
end
