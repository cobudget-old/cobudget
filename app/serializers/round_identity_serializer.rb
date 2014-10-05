class RoundIdentitySerializer < ActiveModel::Serializer
  attributes :id, :name

  def name
    "#{object.budget.name} #1" if object.budget
  end
end
