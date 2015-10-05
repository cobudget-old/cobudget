class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :name, :email
  has_many :groups
  has_many :memberships
end
