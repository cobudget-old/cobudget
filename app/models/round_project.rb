class RoundProject < ActiveRecord::Base
  belongs_to :round
  belongs_to :project
end