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

  describe "#create" do
    before do
      make_user_group_admin
      request.headers.merge!(user.create_new_auth_token)
      group_params = {
        name: 'test',
        currency_code: 'NZD'
      }
      post :create, {group: group_params}
      @new_group = Group.find_by(group_params)
      @parsed_response = JSON.parse(response.body)
    end

    it "creates a new group with specified params" do
      expect(@new_group).to be_truthy
    end

    it "adds current_user as admin to that group" do
      expect(Membership.find_by(group: @new_group, member: user, is_admin: true)).to be_truthy
    end

    it "returns new group, as json" do
      expect(@parsed_response["groups"][0]["id"]).to eq(@new_group.id)
    end
  end
end
