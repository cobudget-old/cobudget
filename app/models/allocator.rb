class Allocator < ActiveRecord::Base
  belongs_to :person
  belongs_to :budget
end