require 'rails_helper'

describe "Buckets" do
  describe "POST /buckets" do
    let(:bucket_params) { {
      bucket: {
        name: 'Do things',
        round_id: round.id,
        user_id: user.id,
        target: "25"
      }
    }.to_json }

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

      it 'can create buckets if enabled on round'
    end
  end

  describe "PUT /buckets" do
    let(:bucket) { FactoryGirl.create(:bucket, round: round, target: 1) }
    let(:new_user) { FactoryGirl.create(:user) }
    let(:evil_round) { FactoryGirl.create(:round) }
    let(:bucket_params) { {
      bucket: {
        name: 'Do more things',
        round_id: evil_round.id,
        user_id: new_user.id,
        target: "25"
      }
    }.to_json }

    context 'admin' do
      before { make_user_group_admin }

      it "updates a bucket" do
        put "/buckets/#{bucket.id}", bucket_params, request_headers
        expect(response.status).to eq updated
        expect(bucket.reload.target).to eq 25
        expect(bucket.user).to eq new_user
        expect(bucket.round_id).not_to eq evil_round.id
      end
    end

    context 'member' do
      before { make_user_group_member }

      it "cannot update buckets" do
        put "/buckets/#{bucket.id}", bucket_params, request_headers
        expect(response.status).to eq forbidden
        expect(bucket.reload.target).not_to eq 25
      end

      it 'can update their own bucket if enabled on round'
    end
  end

  describe "DELETE /buckets/:bucket_id" do
    context 'admin' do
      before { make_user_group_admin }
      it "deletes a bucket (and associated dependencies)" do
        bucket
        contribution
        delete "/buckets/#{bucket.id}", {}, request_headers
        expect(response.status).to eq updated
        expect { bucket.reload }.to raise_error # deleted
        expect { contribution.reload }.to raise_error # deleted
      end
    end

    context 'member' do
      before { make_user_group_member }

      it "cannot delete a bucket" do
        bucket
        delete "/buckets/#{bucket.id}", {}, request_headers
        expect(response.status).to eq forbidden
        expect { bucket.reload }.not_to raise_error # not deleted
      end

      it 'can delete their own bucket if enabled on round'
    end
  end

end
