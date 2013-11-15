def users
  @users ||= {}
end

Given /^a user ([^ ]*)$/ do |user_name|
  @users ||= {}
  @users[user_name] = @user = Cobudget::User.create(name: user_name, email: "#{user_name}@example.com")
end