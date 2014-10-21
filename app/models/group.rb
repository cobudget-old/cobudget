class Group < ActiveRecord::Base
  has_many :rounds, dependent: :destroy
end
