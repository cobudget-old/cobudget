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

      context "bucket archived" do
        before do
          BucketService.archive(bucket, user)
          post :open_for_funding, { id: bucket.id }
          bucket.reload
        end

        it "returns http status 'forbidden'" do
          expect(response).to have_http_status(:forbidden)
        end

        it "does nothing to bucket" do
          expect(bucket.is_cancelled?).to be true
          expect(bucket.live_at).to be_nil
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

        context "bucket is archived" do
          before do
            group.add_admin(user)
            BucketService.archive(bucket, user)
            post :update, bucket_params
            bucket.reload
          end

          it "returns http status 'forbidden'" do
            expect(response).to have_http_status(:forbidden)
          end

          it "does not update bucket" do
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
          @memberships = contributions.map { |contribution| 
            m = contribution.user.membership_for(group) 
            create(:transaction, from_account_id: m.status_account_id, 
              to_account_id: bucket.account_id, amount: 10, user_id: contribution.user.id)
            m
          }
          post :archive, { id: bucket.id }
          bucket.reload
        end

        it "sets archived_at on bucket" do
          expect(bucket.archived_at).not_to be_nil
        end

        it "returns funds back to funders" do
          @memberships.each do |membership|
            expect(membership.reload.balance).to eq(10)
            expect(Account.find(membership.status_account_id).balance).to eq(10)
            expect(Transaction.find_by(from_account_id: bucket.account_id,
              to_account_id: membership.status_account_id, amount: 10, user_id: user.id)).to be_truthy
          end

          expect(bucket.total_contributions).to eq(0)
          expect(Account.find(bucket.account_id).balance).to eq(0)
        end

        it "sends refund notification emails to funders" do
          sent_emails = ActionMailer::Base.deliveries
          recipients = sent_emails.map { |email| email.to.first }
          contributor_emails = @memberships.map { |membership| membership.member.email }
          expect(recipients).to match_array(contributor_emails)
          expect(sent_emails.first.body).to include("cancelled")
        end

        it "returns bucket as json" do
          expect(parsed(response)["buckets"][0]["id"]).to eq(bucket.id)
        end
      end

      context "live bucket, one member is archived before cancel" do
        before do
          @admins = create_list(:user, 2)
          @admins.each { |admin| create(:membership, group: group, member: admin, is_admin: true) }
          bucket.update(status: "live")
          contributions = create_list(:contribution, 2, bucket: bucket, amount: 10)
          @memberships = contributions.map { |contribution| 
            m = contribution.user.membership_for(group) 
            create(:transaction, from_account_id: m.status_account_id, 
              to_account_id: bucket.account_id, amount: 10, user_id: contribution.user.id)
            m
          }
          @memberships[1].update(archived_at: DateTime.now.utc)
          post :archive, { id: bucket.id }
          bucket.reload
          @group_user = User.find_by(uid: %(group@group-#{group.id}.co))
          @group_membership = Membership.find_by(member_id: @group_user.id, group_id: group.id)
        end

        it "sets archived_at on bucket" do
          expect(bucket.archived_at).not_to be_nil
        end

        it "group user and membership exists" do
          expect(@group_user).to be_truthy
          expect(@group_membership).to be_truthy
        end

        it "returns funds back to funders or group account" do
          @memberships.each do |membership|
            if membership.archived_at
              expect(membership.reload.balance).to eq(0)
              expect(Account.find(membership.status_account_id).balance).to eq(0)
              expect(Transaction.find_by(from_account_id: bucket.account_id,
                to_account_id: @group_membership.status_account_id, amount: 10, user_id: user.id)).to be_truthy
            else
              expect(membership.reload.balance).to eq(10)
              expect(Account.find(membership.status_account_id).balance).to eq(10)
              expect(Transaction.find_by(from_account_id: bucket.account_id,
                to_account_id: membership.status_account_id, amount: 10, user_id: user.id)).to be_truthy
            end
          end

          expect(bucket.total_contributions).to eq(0)
          expect(Account.find(bucket.account_id).balance).to eq(0)
        end

        it "sends refund notification emails to funders and admins" do
          sent_emails = ActionMailer::Base.deliveries
          recipients = sent_emails.map { |email| email.to.first }
          actual_memberships = @memberships.reduce([]) { |l, e| e.archived_at ? l : l.push(e) }
          contributor_emails = actual_memberships.map { |membership| membership.member.email }
          expected_emails = @admins.reduce(contributor_emails) { |l, a| l.push(a.email) }
          expect(recipients).to match_array(expected_emails)
          expect(sent_emails.first.body).to include("cancelled")
        end

        it "sends notification to admins" do

        end

        it "returns bucket as json" do
          expect(parsed(response)["buckets"][0]["id"]).to eq(bucket.id)
        end
      end

      context "funded bucket" do
        before do
          bucket.update(status: "funded")
          contributions = create_list(:contribution, 2, bucket: bucket, amount: 100)
          @memberships = contributions.map { |contribution| 
            m = contribution.user.membership_for(group) 
            create(:transaction, from_account_id: m.status_account_id, 
              to_account_id: bucket.account_id, amount: 100, user_id: contribution.user.id)
            m
          }
          post :archive, { id: bucket.id }
          bucket.reload
        end

        it "sets archived_at on bucket" do
          expect(bucket.archived_at).not_to be_nil
        end

        it "updates bucket status to refunded" do
          expect(bucket.status).to eq("refunded")
        end

        it "returns funds back to funders" do
          @memberships.each do |membership|
            expect(membership.reload.balance).to eq(100)
            expect(Account.find(membership.status_account_id).balance).to eq(100)
            expect(Transaction.find_by(from_account_id: bucket.account_id,
              to_account_id: membership.status_account_id, amount: 100, user_id: user.id)).to be_truthy
          end

          expect(bucket.total_contributions).to eq(0)
          expect(Account.find(bucket.account_id).balance).to eq(0)
        end

        it "sends refund notification emails to funders" do
          sent_emails = ActionMailer::Base.deliveries
          recipients = sent_emails.map { |email| email.to.first }
          contributor_emails = @memberships.map { |membership| membership.member.email }
          expect(recipients).to match_array(contributor_emails)
          expect(sent_emails.first.body).to include("cancelled")
        end

        it "returns bucket as json" do
          expect(parsed(response)["buckets"][0]["id"]).to eq(bucket.id)
        end
      end

      context "funded, archived bucket" do
        # this is to support legacy funded, archived buckets
        before do
          contributions = create_list(:contribution, 2, bucket: bucket, amount: 100)
          @memberships = contributions.map { |contribution| 
            m = contribution.user.membership_for(group) 
            create(:transaction, from_account_id: m.status_account_id, 
              to_account_id: bucket.account_id, amount: 100, user_id: contribution.user.id)
            m
          }
          bucket.update(status: "funded", archived_at: DateTime.now.utc)
          post :archive, { id: bucket.id }
          bucket.reload
        end

        it "updates bucket status to refunded" do
          expect(bucket.status).to eq("refunded")
        end

        it "returns funds back to funders" do
          @memberships.each do |membership|
            expect(membership.reload.balance).to eq(100)
            expect(Account.find(membership.status_account_id).balance).to eq(100)
            expect(Transaction.find_by(from_account_id: bucket.account_id,
              to_account_id: membership.status_account_id, amount: 100, user_id: user.id)).to be_truthy
          end

          expect(bucket.total_contributions).to eq(0)
          expect(Account.find(bucket.account_id).balance).to eq(0)
        end

        it "sends refund notification emails to funders" do
          sent_emails = ActionMailer::Base.deliveries
          recipients = sent_emails.map { |email| email.to.first }
          contributor_emails = @memberships.map { |membership| membership.member.email }
          expect(recipients).to match_array(contributor_emails)
          expect(sent_emails.first.body).to include("cancelled")
        end

        it "returns bucket as json" do
          expect(parsed(response)["buckets"][0]["id"]).to eq(bucket.id)
        end
      end
    end
  end

  describe "#paid" do
    describe "permissions" do
      context "user signed in" do
        before {
          request.headers.merge!(user.create_new_auth_token)
          bucket.update(status: "funded")
        }

        context "user is group member" do
          let!(:membership) { create(:membership, group: group, member: user) }

          context "user is admin" do
            it "returns http status 'success'" do
              membership.update(is_admin: true)
              post :paid, { id: bucket.id }
              expect(response).to have_http_status(:success)
            end
          end

          context "user is bucket author" do
            it "returns http status 'success'" do
              bucket.update(user: user)
              post :paid, { id: bucket.id }
              expect(response).to have_http_status(:success)
            end
          end

          context "user is neither bucket author or admin" do
            it "returns http status 'forbidden'" do
              post :paid, { id: bucket.id }
              expect(response).to have_http_status(:forbidden)
            end
          end
        end

        context "user is not group member" do
          it "returns http status 'forbidden'" do
            post :paid, { id: bucket.id }
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context "user not signed in" do
        it "returns http status 'unauthorized'" do
          post :paid, { id: bucket.id }
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

      context "live bucket" do
        before do
          bucket.update(status: "live")
          post :paid, { id: bucket.id }
          bucket.reload
        end

        it "returns http status 'forbidden'" do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context "funded bucket" do
        before do
          bucket.update(status: "funded")
          post :paid, { id: bucket.id }
          bucket.reload
        end

        it "sets paid_at on bucket" do
          expect(bucket.paid_at).not_to be_nil
        end

        it "make sure archived_at is null" do
          expect(bucket.archived_at).to be_nil
        end

        it "returns bucket as json" do
          expect(parsed(response)["buckets"][0]["id"]).to eq(bucket.id)
        end
      end

      context "funded, archived bucket" do
        # this is to support legacy funded, archived buckets
        before do
          BucketService.archive(bucket, user)
          bucket.update(status: "funded")
          post :paid, { id: bucket.id }
          bucket.reload
        end

        it "sets paid_at" do
          expect(bucket.paid_at).not_to be_nil
        end

        it "removes archived_at on bucket" do
          expect(bucket.archived_at).to be_nil
        end
      end
    end
  end
end
