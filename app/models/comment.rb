class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :bucket

  validates :user_id, presence: true
  validates :bucket_id, presence: true
  validates :body, presence: true

  def author_name
    membership = user.membership_for(bucket.group)
    membership.archived? ? "[removed user]" : user.name
  end
end
