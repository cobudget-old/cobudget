class UserService
  def self.set_utc_offset(user: , utc_offset:)
    user.update(utc_offset: utc_offset)
  end
end