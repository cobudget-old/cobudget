class Allocator < ActiveRecord::Base
  belongs_to :person
  belongs_to :budget

  delegate :name, to: :person, allow: nil
end