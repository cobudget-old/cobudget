class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :bucket

  validates :user_id, presence: true
  validates :bucket_id, presence: true
  validates :body, presence: true

  # add helper method to the UserMailer, takes an argument (text) returns rendered text
  def body_as_markdown
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    markdown.render(body).html_safe
  end

  def author_name
    membership = user.membership_for(bucket.group)
    membership.archived? ? "[removed user]" : user.name
  end
end
