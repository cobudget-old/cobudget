require 'rails_helper'

describe "Groups" do
  describe "POST /groups" do
    let(:group_params) { {
      group: {
        name: "Enspiri",
      }
    }.to_json }

    it "creates a group" do
      post "/groups", group_params, request_headers
      group = Group.first
      expect(response.status).to eq created
      expect(group.name).to eq "Enspiri"
      expect(user.is_admin_for?(group)).to eq true
    end
  end
end

