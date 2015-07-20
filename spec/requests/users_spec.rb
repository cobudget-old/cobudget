require 'rails_helper'

describe "Users" do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  context 'resetting password when logged out' do
    let(:request_headers) { logged_out_headers }

    describe "POST /users/reset_password" do
      let(:user) { create(:user) }
      let(:user_params) {
        { user:
          { email: user.email }
        }.to_json
      }

      it 'sends password reset email' do
        post "/users/reset_password", user_params, request_headers

        email = ActionMailer::Base.deliveries.last
        expect(response.status).to eq created
        expect(email.to[0]).to match(user.email)
        expect(email.subject).to match('password')
      end
    end

    describe "PUT /users/reset_password" do
      let(:user) { create(:user) }
      let(:token) { user.send_reset_password_instructions }
      let(:user_params) { {user: reset_password_params}.to_json }
      let(:reset_password_params) {
        { reset_password_token: token,
          password: 'johnkeyisgreat',
          password_confirmation: 'johnkeyisgreat'
        }
      }

      context 'correct reset token' do
        it 'resets password' do
          put "/users/reset_password", user_params, request_headers
          user.reload
          expect(response.status).to eq updated
          expect(user.valid_password?('johnkeyisgreat')).to eq(true)
        end
      end
    end
  end

  describe "PUT /users/:user_id" do
    let(:user) { create(:user) }
    let(:user_params) {
      { user:
        { name: 'Giddy TooGood',
          email: 'giddy@toogood.gov',
          password: 'johnkeyisgreat'
        }
      }.to_json
    }
    context 'user' do
      it "updates their details (except for password)" do
        put "/users/#{user.id}/", user_params, request_headers
        user.reload
        expect(response.status).to eq updated
        expect(user.name).to eq 'Giddy TooGood'
        expect(user.email).to eq 'giddy@toogood.gov'
        expect(user.valid_password?('johnkeyisgreat')).to eq false
      end
      context 'is uninitialized' do
        let(:user) { create(:user, initialized: false) }
        it 'allows password update' do
          put "/users/#{user.id}/", user_params, request_headers
          user.reload
          expect(response.status).to eq updated
          expect(user.valid_password?('johnkeyisgreat')).to eq true
        end
        it 'sets initialized to true' do
          user.update(initialized: false)
          put "/users/#{user.id}/", user_params, request_headers
          user.reload
          expect(response.status).to eq updated
          expect(user.initialized).to eq true
        end
      end
      context "trying to update another user's details" do
        it 'fails' do
          put "/users/#{another_user.id}/", user_params, request_headers
          expect(response.status).to eq forbidden
          another_user.reload
          expect(another_user.name).not_to eq 'Giddy TooGood'
        end
      end
    end
  end

  describe "POST /users/:user_id/change_password" do
    context "old password is correct" do
      let(:password_params) {
        { user:
          { old_password: user.password,
            new_password: 'realgood'}
        }.to_json
      }

      it "changes user's password" do
        post "/users/#{user.id}/change_password", password_params, request_headers
        expect(response.status).to eq updated
        expect(user.reload.valid_password?('realgood')).to eq true
      end

      context 'trying to change password of another user' do
        it 'doesnt work' do
          post "/users/#{another_user.id}/change_password", password_params, request_headers
          expect(response.status).to eq forbidden
          expect(another_user.reload.valid_password?('realgood')).to eq false
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
    end

    it "doesn't change user's password if old password is incorrect" do
      password_params = { user:
        { old_password: 'bad password',
          new_password: 'realgood'}
      }.to_json

      post "/users/#{user.id}/change_password", password_params, request_headers

      expect(user.reload.valid_password?('realgood')).to eq false
      expect(response.status).to eq 400
    end
  end

  describe "GET /users/" do
    it "displays users" do
      user2 = create(:user)

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
