class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :name, :email, :utc_offset
end
