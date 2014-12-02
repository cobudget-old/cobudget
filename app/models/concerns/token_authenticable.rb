# Code taken from:
# https://gist.github.com/gonzalo-bulnes/7659739

module TokenAuthenticable
  extend ActiveSupport::Concern

  # Please see https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
  # before editing this file, the discussion is very interesting.

  included do
    private :generate_access_token

    before_save :ensure_access_token
  end

  def ensure_access_token
    if access_token.blank?
      self.access_token = generate_access_token
    end
  end

  def generate_access_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(access_token: token).first
    end
  end

  module ClassMethods
    # nop
  end
end
