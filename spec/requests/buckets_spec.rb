require 'rails_helper'

describe "Buckets" do
  let(:user) { FactoryGirl.create(:user) }
  let(:round) { FactoryGirl.create(:round) }
  let(:membership) { FactoryGirl.create(:membership, group: round.group, user: user) }
  let(:admin_membership) { FactoryGirl.create(:membership,
                           group: round.group, user: user, is_admin: true) }

  describe "POST /buckets" do
    let(:bucket_params) { {
      bucket: {
        name: 'Do things',
        round_id: round.id,
        user_id: user.id,
        target_cents: 2500
      }
    }.to_json }

    context 'admin' do
      before { admin_membership }

      it "creates a bucket" do
        post "/buckets", bucket_params, request_headers
        bucket = Bucket.first
        expect(response.status).to eq 201
        expect(bucket.target_cents).to eq 2500
        expect(bucket.user).to eq user
      end
    end

    context 'user' do
      it "cannot create buckets" do
        post "/buckets", bucket_params, request_headers
        bucket = Bucket.first
        expect(response.status).to eq 403
        expect(bucket).to eq nil
      end
    end
  end
end
