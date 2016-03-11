require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "#create" do
    let(:valid_params) { {comment: {bucket_id: bucket.id, body: "hello dix"}} }
    let(:invalid_params) { {comment: {bucket_id: bucket.id, body: ""}} }

    context "user signed in" do
      before { request.headers.merge!(user.create_new_auth_token) }

      context "user member of group" do
        before { make_user_group_member }

        context "valid params" do
          it "returns http status 'success'" do
            post :create, valid_params
            expect(response).to have_http_status(:success)
          end
        end

        context "invalid params" do
          it "returns http status 'unprocessable'" do
            post :create, invalid_params
            expect(response).to have_http_status(422)
          end
        end
      end

      context "user not member of group" do
        it "returns http status 'forbidden'" do
          post :create, valid_params
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context "user not signed in" do
      it "returns http status 'unauthorized'" do
        post :create, valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end
