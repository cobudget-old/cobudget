class Project < ActiveRecord::Base
  belongs_to :budget
  monetize :min_cents
  monetize :target_cents
  monetize :max_cents

end