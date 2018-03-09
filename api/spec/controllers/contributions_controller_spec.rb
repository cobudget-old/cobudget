require 'rails_helper'

RSpec.describe ContributionsController, type: :controller do
  describe "#create" do
    let!(:user) { create(:user) }
    let!(:admin) { create(:user) }
    let!(:group) { create(:group) }
    let!(:bucket) { create(:bucket, group: group) }

    context "user signed in" do
      before { request.headers.merge!(user.create_new_auth_token) }

      context "user is member of group" do
        let!(:membership) { create(:membership, member: user, group: group) }

        before do
          bucket.update(target: 100)
          bucket.update(status: 'live')
        end

        context "contribution amount does not exceed contributor's balance" do
          before do
            create(:allocation, user: user, group: group, amount: 100)
            create(:transaction,
              from_account_id: membership.incoming_account_id,
              to_account_id: membership.status_account_id,
              user_id: admin.id,
              amount: 100)
          end

          context "contribution amount does not exceed bucket's funding target" do
            before do
              contribution_params = {
                bucket_id: bucket.id,
                amount: 100
              }
              post :create, {contribution: contribution_params}
              @contribution = Contribution.find_by(contribution_params)
              @transaction = Transaction.find_by(to_account_id: bucket.account_id, amount: 100)
            end

            it "returns http status ok" do
              expect(response).to have_http_status(:ok)
            end

            it "creates contribution for current_user with specified amount" do
              expect(@contribution).to be_truthy
            end

            it "creates transaction with specified amount and the contributor as owner" do
              expect(@transaction).to be_truthy
              expect(@transaction.user_id).to eq(user.id)
            end

            it "returns the contribution as json" do
              parsed_response = JSON.parse(response.body)
              expect(parsed_response["contributions"][0]["id"]).to eq(@contribution.id)
            end
          end

          context "contribution amount meets bucket's funding target" do
            it "updates bucket status to 'funded'" do
              contribution_params = {
                bucket_id: bucket.id,
                amount: 100
              }
              post :create, {contribution: contribution_params}
              expect(bucket.reload.status).to eq('funded')
            end
          end

          context "contribution amount exceeds bucket's funding target" do
            it "contribution amount is decreased to exactly meet the bucket's funding target" do
              create(:allocation, user: user, group: group, amount: 1000)
              create(:transaction,
                from_account_id: membership.incoming_account_id,
                to_account_id: membership.status_account_id,
                user_id: admin.id,
                amount: 1000)

              contribution_params = {
                bucket_id: bucket.id,
                amount: 150
              }
              post :create, {contribution: contribution_params}
              @contribution = Contribution.find_by(bucket: bucket)
              expect(@contribution.amount).to eq(100)

              @transaction = Transaction.find_by(to_account_id: bucket.account_id)
              expect(@transaction.amount).to eq(100)
            end
          end
        end

        context "contribution amount exceeds contributor's balance" do
          before do
            create(:allocation, user: user, amount: 10)
            create(:transaction,
                from_account_id: membership.incoming_account_id,
                to_account_id: membership.status_account_id,
                user_id: admin.id,
                amount: 10)

            contribution_params = {
              bucket_id: bucket.id,
              amount: 50
            }
            post :create, {contribution: contribution_params}
            @contribution = Contribution.find_by(contribution_params)
            @transaction = Transaction.find_by(to_account_id: bucket.account_id, amount: 50)
          end

          it "returns http status unprocessable" do
            expect(response).to have_http_status(422)
          end

          it "does not create the contribution" do
            expect(@contribution).to be_nil
          end

          it "does not create the transaction" do
            expect(@transaction).to be_nil
          end
        end
      end

      context "user not member of group" do
        it "returns http status 'forbidden'" do
          contribution_params = {
            bucket_id: bucket.id,
            amount: 50
          }
          post :create, {contribution: contribution_params}
          expect(response).to have_http_status(:forbidden)
        end
      end

      context "bucket is archived" do
        before do
          group.add_member(user)
          create(:allocation, user: user, group: group, amount: 100)
          BucketService.archive(bucket, user)
          post :create, {contribution: { bucket_id: bucket.id, amount: 50 } }
        end

        it "returns http status 422" do
          expect(response).to have_http_status(422)
        end
      end
    end

    context "user not signed in" do
      it "returns http status 'unauthorized'" do
        contribution_params = {
          bucket_id: bucket.id,
          amount: 50
        }
        post :create, {contribution: contribution_params}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
