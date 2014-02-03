def users
  @users ||= {}
end

Given /^a user ([^ ]*)$/ do |user_name|
  @users ||= {}
  @users[user_name] = @user = Cobudget::User.create(name: user_name, email: "#{user_name}@example.com")
end

Given /^(#{CAPTURE_USER}) has a background colour of ([^ ]*)$/ do |user, colour|
  options = {}

end

Then /^the ([^ ]*) user should not exist$/ do |user_name|
  users[user_name].should be_nil
end

When /^([^ ]*) updates (#{CAPTURE_USER}) with:$/ do |user_name, user, table|
  user = users[user_name]

  options = table.rows_hash.symbolize_keys
  options.merge!(user: user)
  play.update_users(options)
end

Then /^(#{CAPTURE_USER}) should have the email "(.*?)"$/ do |user, email|
  user.email.should == email
end

Then /^(#{CAPTURE_USER}) should have background colour (.*?)$/ do |user, colour|
  user.bg_color.should == colour
end

Then /^(#{CAPTURE_USER}) should have foreground colour (.*?)$/ do |user, colour|
  user.fg_color.should == colour
end
