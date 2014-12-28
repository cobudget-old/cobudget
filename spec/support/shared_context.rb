module MyLetDeclarations
  extend RSpec::SharedContext

  # Everything you need for a basic test
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  let(:round) { FactoryGirl.create(:round, group: group) }

  # Convenience methods for testing permissions
  let(:make_user_group_member) { FactoryGirl.create(:membership, group: group, user: user) }
  let(:make_user_group_admin) { FactoryGirl.create(:membership,
                           group: group, user: user, is_admin: true) }

  # HTTP status codes
  let(:success) { 200 }
  let(:created) { 201 }
  let(:updated) { 204 }
  let(:forbidden) { 403 }

  let(:request_headers) { {
    "Accept" => "application/json",
    "Content-Type" => "application/json",
    "X-User-Token" => user.access_token,
    "X-User-Email" => user.email,
  } }
end
RSpec.configure { |c| c.include MyLetDeclarations }
