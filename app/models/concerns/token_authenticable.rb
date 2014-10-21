# Code taken from:
# https://gist.github.com/gonzalo-bulnes/7659739

module TokenAuthenticable
  extend ActiveSupport::Concern

  # Please see https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
  # before editing this file, the discussion is very interesting.

  included do
    private :generate_authentication_token

    before_save :ensure_authentication_token
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  module ClassMethods
    # nop
  end
end
