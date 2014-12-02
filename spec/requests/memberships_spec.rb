require 'rails_helper'

describe "Memberships" do
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }

  let(:request_headers) { {
    "Accept" => "application/json",
    "Content-Type" => "application/json",
    "X-User-Token" => user.access_token,
    "X-User-Email" => user.email,
  } }

  describe "GET /groups/:group_id/memberships/" do
    it "displays memberships for a group" do
      membership1 = FactoryGirl.create(:membership, group_id: group.id)
      membership2 = FactoryGirl.create(:membership, group_id: group.id)

      get "/groups/#{group.id}/memberships/", {}, request_headers

      expect(response.status).to eq 200 # success

      body = JSON.parse(response.body)
      usernames = []
      usernames << body["memberships"][0]["user"]["name"]
      usernames << body["memberships"][1]["user"]["name"]
      expect(usernames).to include membership1.user.name
      expect(usernames).to include membership2.user.name
    end
  end

  describe "POST /memberships" do
    it "creates a membership" do
      membership_params = {
        membership: {
          user_id: user.id,
          group_id: group.id
        }
      }.to_json

      post "/memberships", membership_params, request_headers

      membership = Membership.first

      expect(response.status).to eq 201 # created
      expect(membership.user).to eq user
      expect(membership.group).to eq group
      expect(membership.is_admin?).to eq false
    end
  end

  describe "PUT /memberships/:membership_id" do
    let(:membership) { FactoryGirl.create(:membership) }

    it "updates a membership" do
      membership_params = {
        membership: {
          is_admin: true
        }
      }.to_json
      expect(membership.is_admin?).to eq false

      put "/memberships/#{membership.id}", membership_params, request_headers

      membership.reload
      expect(response.status).to eq 204 # updated
      expect(membership.is_admin?).to eq true
    end
  end

  describe "DELETE /memberships/:membership_id" do
    let(:membership) { FactoryGirl.create(:membership) }

    it "deletes a membership" do

      delete "/memberships/#{membership.id}", {}, request_headers

      expect(response.status).to eq 204 # updated
      expect { membership.reload }.to raise_error # deleted
    end
  end
end
