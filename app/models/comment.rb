class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :bucket

  def author_name
    user.name
  end
end
