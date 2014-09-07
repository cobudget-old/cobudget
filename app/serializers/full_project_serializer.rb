class FullProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :min_cents, :target_cents, :max_cents
end
