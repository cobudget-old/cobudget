require 'rails_helper'

RSpec.describe BucketsController, type: :controller do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:bucket) { create(:bucket, group: group, status: 'draft') }

  after { ActionMailer::Base.deliveries.clear }

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

  describe "#archive" do
    describe "permissions" do
      context "user signed in" do
        before { request.headers.merge!(user.create_new_auth_token) }

        context "user is group member" do
          let!(:membership) { create(:membership, group: group, member: user) }

          context "user is admin" do
            it "returns http status 'success'" do
              membership.update(is_admin: true)
              post :archive, { id: bucket.id }
              expect(response).to have_http_status(:success)
            end
          end

          context "user is bucket author" do
            it "returns http status 'success'" do
              bucket.update(user: user)
              post :archive, { id: bucket.id }
              expect(response).to have_http_status(:success)
            end
          end

          context "user is neither bucket author or admin" do
            it "returns http status 'forbidden'" do
              post :archive, { id: bucket.id }
              expect(response).to have_http_status(:forbidden)
            end
          end
        end

        context "user is not group member" do
          it "returns http status 'forbidden'" do
            post :archive, { id: bucket.id }
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context "user not signed in" do
        it "returns http status 'unauthorized'" do
          post :archive, { id: bucket.id }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context "behavior" do
      before do
        group.add_member(user)
        bucket.update(user: user)
        request.headers.merge!(user.create_new_auth_token)
      end

      context "draft bucket" do
        before do
          post :archive, { id: bucket.id }
          bucket.reload
        end

        it "sets archived_at on bucket" do
          expect(bucket.archived_at).not_to be_nil
        end

        it "returns bucket as json" do
          expect(parsed(response)["buckets"][0]["id"]).to eq(bucket.id)
        end
      end

      context "live bucket" do
        before do
          bucket.update(status: "live")
          contributions = create_list(:contribution, 2, bucket: bucket, amount: 10)
          @memberships = contributions.map { |contribution| contribution.user.membership_for(group) }
          post :archive, { id: bucket.id }
          bucket.reload
        end

        it "sets archived_at on bucket" do
          expect(bucket.archived_at).not_to be_nil
        end

        it "returns funds back to funders" do
          @memberships.each do |membership|
            expect(membership.reload.balance).to eq(10)
          end

          expect(bucket.total_contributions).to eq(0)
        end

        it "sends refund notification emails to funders" do
          sent_emails = ActionMailer::Base.deliveries
          recipients = sent_emails.map { |email| email.to.first }
          contributor_emails = @memberships.map { |membership| membership.member.email }
          expect(recipients).to match_array(contributor_emails)
          expect(sent_emails.first.body).to include("archived")
        end

        it "returns bucket as json" do
          expect(parsed(response)["buckets"][0]["id"]).to eq(bucket.id)
        end
      end

      context "funded bucket" do
        before do
          bucket.update(target: 200)
          @contribution = create(:contribution, bucket: bucket, amount: 200)
          post :archive, { id: bucket.id }
          bucket.reload
        end

        it "sets archived_at on bucket" do
          expect(bucket.archived_at).not_to be_nil
        end

        it "does not return funds back to funders" do
          expect(bucket.total_contributions).to eq(200)
          expect(@contribution.user.membership_for(group).balance).to eq(0)
        end

        it "returns bucket as json" do
          expect(parsed(response)["buckets"][0]["id"]).to eq(bucket.id)
        end
      end
    end
  end
end
