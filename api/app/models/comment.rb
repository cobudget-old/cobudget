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

  def body_html
    # convert markdown body to html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
    red_body = markdown.render(body)

    # break the html into fragments
    noko_body = Nokogiri::HTML.fragment(red_body)

    # get an array of all the user ids from the link values
    user_links = noko_body.css("a").map {|a|
      a.attributes.values[0].value.sub! 'uid:', ''
    }

    # format the links with the correct base url
    noko_body.css("a").map do |a|
      a['href'].sub! 'uid:', ''
      a.attributes["href"].value = "http://#{Rails.application.config.action_mailer.default_url_options[:host]}/##{a['href'].sub! 'uid:', '/users/'}"
    end

    noko_body.to_html
  end
end
