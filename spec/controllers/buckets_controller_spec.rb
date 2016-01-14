require 'rails_helper'

RSpec.describe BucketsController, type: :controller do
  describe "#update" do
    let!(:bucket) { create(:bucket) }
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
