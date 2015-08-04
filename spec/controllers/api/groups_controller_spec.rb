require 'rails_helper'

describe GroupsController, :type => :controller do
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