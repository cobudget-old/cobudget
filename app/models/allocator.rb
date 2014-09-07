class Allocator < ActiveRecord::Base
  belongs_to :person
  belongs_to :budget
  has_many :allocation_rights
  has_many :allocations

  delegate :name, to: :person, allow: nil

  def allocation_rights_total_cents
    allocation_rights.sum(:amount_cents)
  end
end