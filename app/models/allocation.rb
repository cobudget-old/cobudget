class Allocation < ActiveRecord::Base
  belongs_to :bucket
  belongs_to :allocator
end