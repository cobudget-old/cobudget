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

  describe "GET /groups?member_id=1" do

    before(:each) do
      @user = create(:user)
      @group1 = create(:group)
      @group2 = create(:group)
      @membership1 = create(:membership, group_id: @group1.id, member_id: @user.id)
    end

    it "gets groups" do
      expect(Group.count).to eq 2
      get "/groups", {}, request_headers

      expect(response.status).to eq success

      groups = JSON.parse(response.body)['groups']
      expect(groups.length).to eq 2
      expect(groups[0]['id']).to eq @group1.id
      expect(groups[1]['id']).to eq @group2.id
    end

    it "gets groups of member" do
      expect(Group.count).to eq 2
      get "/groups?member_id=#{@user.id}", {}, request_headers

      expect(response.status).to eq success

      groups = JSON.parse(response.body)['groups']
      expect(groups.length).to eq 1
      expect(groups[0]['id']).to eq @group1.id
    end
  end
end