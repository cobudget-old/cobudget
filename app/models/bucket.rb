class Bucket < ActiveRecord::Base
  has_many :allocations
end