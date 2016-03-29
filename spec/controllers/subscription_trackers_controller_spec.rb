require "rails_helper"

describe SubscriptionTrackersController, :type => :controller do
  describe "#update_email_settings" do
    let(:user) { create(:user) }
    let(:subscription_tracker) { user.subscription_tracker }
    let(:valid_params) {{
      subscription_tracker: {
        comments_on_buckets_user_authored: true,
        comments_on_buckets_user_participated_in: false,
        new_draft_buckets: true,
        new_live_buckets: false,
        new_funded_buckets: false,
        contributions_to_live_buckets_user_authored: true,
        contributions_to_live_buckets_user_participated_in: true,
        funded_buckets_user_authored: false,
        notification_frequency: "weekly"
      }
    }}

    let(:invalid_params) {{
      subscription_tracker: {
        notification_frequency: "anti-dramatic refridgerator"
      }
    }}

    context "user signed in" do
      before { request.headers.merge!(user.create_new_auth_token) }

      context "valid params" do
        before { post :update_email_settings, valid_params }

        it "returns http status 'success'" do
          expect(response).to have_http_status(:success)
        end

        it "updates subscription_tracker" do
          expect(SubscriptionTracker.find_by(valid_params[:subscription_tracker]).id).to eq(subscription_tracker.id)
        end

        it "returns subscription_tracker as json" do
          expect(parsed(response)["subscription_trackers"][0]["id"]).to eq(subscription_tracker.id)
        end
      end

      context "invalid params" do
        before { post :update_email_settings, invalid_params }

        it "returns http status 'unprocessable'" do
          expect(response).to have_http_status(422)
        end

        it "does not update subscription_tracker" do
          expect(subscription_tracker.notification_frequency).not_to eq("anti-dramatic refridgerator")
        end
      end
    end

    context "user not signed in" do
      it "returns http status 'unauthorized'" do
        post :update_email_settings, valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
