require 'rails_helper'

RSpec.describe BucketsController, type: :controller do
  describe "#update" do
    let!(:bucket) { create(:bucket, status: 'draft') }
    let!(:group) { bucket.group }
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
