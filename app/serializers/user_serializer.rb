class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true
  has_many :memberships
  attributes :id, :name, :email
end
