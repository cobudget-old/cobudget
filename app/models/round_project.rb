class RoundProject < ActiveRecord::Base
  belongs_to :round
  belongs_to :project
  belongs_to :bucket

  before_create do
    create_bucket
  end
end