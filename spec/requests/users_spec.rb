require 'rails_helper'

describe "Users" do
  let(:round) { FactoryGirl.create(:round) }
  let(:user) { FactoryGirl.create(:user, force_password_reset: true) }
  let(:another_user) { FactoryGirl.create(:user) }

  describe "POST /users/:user_id/change_password" do
    context "old password is correct" do
      let(:password_params) {
        { user:
          { old_password: user.password,
            new_password: 'realgood'}
        }.to_json
      }

      it "changes user's password " do
        post "/users/#{user.id}/change_password", password_params, request_headers
        expect(response.status).to eq updated
        expect(user.reload.valid_password?('realgood')).to eq true
        expect(user.force_password_reset).to eq false
      end

      context 'trying to change password of another user' do
        it 'doesnt work' do
          post "/users/#{another_user.id}/change_password", password_params, request_headers
          expect(response.status).to eq forbidden
          expect(another_user.reload.valid_password?('realgood')).to eq false
          expect(user.force_password_reset).to eq true
        end
      end
    end

    it "doesn't change user's password if new password is too short" do
      password_params = { user:
        { old_password: user.password,
          new_password: 'a'}
      }.to_json

      post "/users/#{user.id}/change_password", password_params, request_headers

      body = JSON.parse(response.body)

      expect(response.status).to eq 400
      expect(body['errors']['password'][0]).to match("too short")
      expect(user.reload.valid_password?('a')).to eq false
      expect(user.reload.force_password_reset).to eq true
    end

    it "doesn't change user's password if old password is incorrect" do
      password_params = { user:
        { old_password: 'bad password',
          new_password: 'realgood'}
      }.to_json

      post "/users/#{user.id}/change_password", password_params, request_headers

      expect(user.reload.valid_password?('realgood')).to eq false
      expect(user.reload.force_password_reset).to eq true
      expect(response.status).to eq 400
    end
  end

  describe "GET /users/" do
    it "displays users" do
      user2 = FactoryGirl.create(:user)

      get "/users/", {}, request_headers

      expect(response.status).to eq success

      body = JSON.parse(response.body)
      names = []
      names << body["users"][0]["name"]
      names << body["users"][1]["name"]
      expect(names).to include(user.name)
      expect(names).to include(user2.name)
    end
  end
end
