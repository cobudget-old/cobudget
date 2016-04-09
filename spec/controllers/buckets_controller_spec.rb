require 'rails_helper'

RSpec.describe BucketsController, type: :controller do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:bucket) { create(:bucket, group: group, status: 'draft') }

  after { ActionMailer::Base.deliveries.clear }

  describe "#open_for_funding" do
    describe "permissions" do
      context "user signed in" do
        before { request.headers.merge!(user.create_new_auth_token) }

        context "user is group member" do
          before { group.add_member(user) }

          context "user is admin" do
            before { group.add_admin(user) }

            it "returns http status 'success'" do
              post :open_for_funding, { id: bucket.id }
              expect(response).to have_http_status(:success)
            end
          end

          context "user is bucket author" do
            before { bucket.update(user: user) }

            it "returns http status 'success'" do
              post :open_for_funding, { id: bucket.id }
              expect(response).to have_http_status(:success)
            end
          end

          context "user is neither admin nor bucket author" do
            it "returns http status 'forbidden'" do
              post :open_for_funding, { id: bucket.id }
              expect(response).to have_http_status(:forbidden)
            end
          end
        end

        context "user is not group member" do
          it "returns http status 'forbidden'" do
            post :open_for_funding, { id: bucket.id }
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context "user not signed in" do
        it "returns http status 'unauthorized'" do
          post :open_for_funding, { id: bucket.id }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    describe "behavior" do
      before do
        request.headers.merge!(user.create_new_auth_token)
        group.add_admin(user)
      end

      context "bucket active" do
        before do
          post :open_for_funding, { id: bucket.id }
          bucket.reload
        end

        it "updates bucket status to live" do
          expect(bucket.status).to eq("live")
        end

        it "sets live_at on bucket" do
          expect(bucket.live_at).not_to be_nil
        end

        it "returns bucket as json" do
          expect(parsed(response)["buckets"][0]["id"]).to eq(bucket.id)
        end
      end
    end
  end

  describe "#update" do
    let(:bucket_params) {{
      id: bucket.id,
      bucket: {
        name: "new name",
        description: "new description",
        target: 420
      }
    }}

    context "user logged in" do
      before { request.headers.merge!(user.create_new_auth_token) }

      context "current_user is member of bucket's group" do
        before { group.add_member(user) }

        context "current_user is bucket author" do
          before do
            bucket.update(user: user)
            patch :update, bucket_params
            bucket.reload
          end

          it "returns http status ok" do
            expect(response).to have_http_status(:ok)
          end

          it "updates bucket" do
            expect(bucket.name).to eq("new name")
          end
        end

        context "current_user is admin" do
          before do
            group.add_admin(user)
            patch :update, bucket_params
            bucket.reload
          end

          it "returns http status ok" do
            expect(response).to have_http_status(:ok)
          end

          it "updates bucket" do
            expect(bucket.name).to eq("new name")
          end
        end

        context "current_user is neither an admin or bucket author" do
          before do
            patch :update, bucket_params
            bucket.reload
          end

          it "returns http status forbidden" do
            expect(response).to have_http_status(:forbidden)
          end

          it "does not update the bucket" do
            expect(bucket.description).not_to eq("new description")
          end
        end

        context "updating target" do
          context "for draft bucket" do
            let!(:draft_bucket) { create(:bucket, status: 'draft', target: 100, group: group) }

            before do
              group.add_admin(user)
              patch :update, {id: draft_bucket.id, bucket: {target: 420}}
              draft_bucket.reload
            end

            it "updates target" do
              expect(draft_bucket.target).to eq(420)
            end

            it "returns http status ok" do
              expect(response).to have_http_status(:ok)
            end
          end

          context "for non-draft bucket" do
            let!(:live_bucket) { create(:bucket, status: 'live', target: 100, group: group) }

            before do
              group.add_admin(user)
              patch :update, {id: live_bucket.id, bucket: {target: 420}}
              live_bucket.reload
            end

            it "does not update target" do
              expect(live_bucket.target).to eq(100)
            end

            it "returns http status bad_request" do
              expect(response).to have_http_status(:bad_request)
            end
          end
        end
      end

      context "current_user not member of bucket's group" do
        before do
          patch :update, bucket_params
          bucket.reload
        end

        it "returns http status forbidden" do
          expect(response).to have_http_status(:forbidden)
        end

        it "does not update the bucket" do
          expect(bucket.description).not_to eq("new description")
        end
      end
    end

    context "user not logged in" do
      before do
        patch :update, bucket_params
      end

      it "returns http status unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "does not update the bucket" do
        expect(bucket.description).not_to eq("new description")
      end
    end
  end
end
