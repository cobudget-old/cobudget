require 'rails_helper'

describe GroupsController, :type => :controller do
  describe "#index" do
    before do
      2.times do
        group = create(:group)
        create(:membership, group: group, member: user)
      end
      5.times { create(:membership) }
      request.headers.merge!(user.create_new_auth_token)
    end

    it "returns a list of groups that the current_user is a member of, as json" do
      get :index
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["groups"].length).to eq(2)
    end
  end

  describe "#show" do
    before do
      make_user_group_member
      request.headers.merge!(user.create_new_auth_token)
    end

    it "returns serialized group" do
      get :show, {id: group.id}
      res = JSON.parse(response.body)
      expect(res["groups"][0]["name"]).to eq(group.name)
    end
  end
end