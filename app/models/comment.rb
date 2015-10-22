class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :bucket

  validates :user_id, presence: true
  validates :bucket_id, presence: true

  def body_as_markdown
    renderer = Redcarpet::Render::HTML.new 
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    markdown.render(body).html_safe
  end
end