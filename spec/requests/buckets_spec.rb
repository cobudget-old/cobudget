require 'rails_helper'

describe "Buckets" do
  let(:round) { create(:round_open_for_proposals, group: group) }

  describe "POST /buckets" do
    let(:bucket_params) { {
      bucket: {
        name: 'Do things',
        round_id: round.id,
        user_id: user.id,
        target: "25"
      }
    }.to_json }

    context 'pending round' do
      let(:round) { create(:round, group: group) }
      context 'admin' do
        before { make_user_group_admin }

        it "creates a bucket" do
          post "/buckets", bucket_params, request_headers
          bucket = Bucket.first
          expect(response.status).to eq 201
          expect(bucket.target).to eq 25
          expect(bucket.user).to eq user
        end
      end

      context 'member' do
        before { make_user_group_member }

        it "cannot create buckets" do
          post "/buckets", bucket_params, request_headers
          bucket = Bucket.first
          expect(response.status).to eq 403
          expect(bucket).to eq nil
        end
      end
    end

    context 'round open for proposals' do
      context 'member' do
        before { make_user_group_member }

        it "creates a bucket" do
          post "/buckets", bucket_params, request_headers
          bucket = Bucket.first
          expect(response.status).to eq 201
          expect(bucket.target).to eq 25
          expect(bucket.user).to eq user
        end
      end
    end
  end

  describe "PUT /buckets" do
    let(:bucket) { create(:bucket, round: round, target: 1, user: user) }
    let(:new_user) { create(:user) }
    let(:evil_round) { create(:round) }
    let(:bucket_params) { {
      bucket: {
        name: 'Do more things',
        round_id: evil_round.id,
        user_id: new_user.id,
        target: "25"
      }
    }.to_json }

    context 'member' do
      before { make_user_group_member }

      it "updates a bucket" do
        put "/buckets/#{bucket.id}", bucket_params, request_headers
        expect(response.status).to eq updated
        expect(bucket.reload.target).to eq 25
        expect(bucket.user).to eq new_user
        expect(bucket.round_id).not_to eq evil_round.id
      end
    end
  end

  describe "DELETE /buckets/:bucket_id" do
    let(:bucket) { create(:bucket, round: round, target: 1, user: user) }
    context 'member' do
      before { make_user_group_member }

      it "deletes a bucket (and associated dependencies)" do
        bucket
        contribution
        delete "/buckets/#{bucket.id}", {}, request_headers
        expect(response.status).to eq updated
        expect { bucket.reload }.to raise_error # deleted
        expect { contribution.reload }.to raise_error # deleted
      end
    end
  end
end
