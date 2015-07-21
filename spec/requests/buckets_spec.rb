require 'rails_helper'

describe "Buckets" do
  describe "POST '/buckets'" do
    let(:bucket_params) { {
      bucket: {
        name: 'Do things',
        group_id: group.id,
        user_id: user.id,
        target: "25"
      }
    }.to_json }

    context "group member" do
      before { make_user_group_member }

      it "creates a new bucket" do
        post "/buckets", bucket_params, request_headers
        expect(response).to have_http_status created
        expect(Bucket.find_by(group: group, user: user, target: 25, name: 'Do things')).to be_truthy
      end
    end

    context "not group member" do
      before { user = create(:user) }

      it "does not create a new bucket" do
        post "/buckets", bucket_params, request_headers
        expect(response).to have_http_status forbidden
        expect(Bucket.find_by(group: group, user: user, target: 25, name: 'Do things')).to be_nil
      end
    end
  end

  describe "PUT '/buckets'" do
    let(:bucket_owner) { create(:user) }
    let(:new_bucket_owner) { create(:user) }
    let(:group) { create(:group) }
    let(:evil_group) { create(:group) }

    let(:bucket) { create(:bucket, target: 1, user: bucket_owner, group: group) }
    let(:bucket_params) { {
      bucket: {
        name: 'Do more things',
        group_id: evil_group.id,
        user_id: new_bucket_owner.id,
        target: "25"
      }
    }.to_json }

    before do
      create(:membership, member: bucket_owner, group: group)
      create(:membership, member: new_bucket_owner, group: group)
    end

    context "bucket owner" do
      it "updates a bucket" do
        owner_request_headers = {
          "X-User-Token" => bucket_owner.access_token,
          "X-User-Email" => bucket_owner.email
        }.merge(logged_out_headers)

        put "/buckets/#{bucket.id}", bucket_params, owner_request_headers
        expect(response).to have_http_status updated
        expect(bucket.reload.target).to eq 25
        expect(bucket.user).to eq new_bucket_owner
        expect(bucket.group_id).not_to eq evil_group.id
      end
    end

    context "admin" do
      it "updates a bucket" do
        admin = create(:user)
        group.add_admin(admin)
        admin_request_headers = {
          "X-User-Token" => admin.access_token,
          "X-User-Email" => admin.email
        }.merge(logged_out_headers)

        put "/buckets/#{bucket.id}", bucket_params, admin_request_headers
        expect(response).to have_http_status updated
        expect(bucket.reload.target).to eq 25
        expect(bucket.user).to eq new_bucket_owner
        expect(bucket.group_id).not_to eq evil_group.id
      end
    end

    context "not owner of bucket" do
      it "does not update the bucket" do
        non_owner = create(:user)
        non_owner_request_headers = {
          "X-User-Token" => non_owner.access_token,
          "X-User-Email" => non_owner.email
        }.merge(logged_out_headers)

        put "/buckets/#{bucket.id}", bucket_params, non_owner_request_headers
        expect(response).to have_http_status forbidden
        expect(bucket.reload.target).not_to eq 25
      end
    end
  end

  describe "DELETE '/buckets/:bucket_id'" do
    ## still gotta refactor this shit

    context "owner of bucket" do
      it "deletes a bucket (and associated dependencies)" do
        contribution
        bucket_owner = bucket.user
        create(:membership, group: bucket.group, member: bucket_owner)

        owner_request_headers = {
          "X-User-Token" => bucket_owner.access_token,
          "X-User-Email" => bucket_owner.email
        }.merge(logged_out_headers)

        delete "/buckets/#{bucket.id}", {}, owner_request_headers

        expect(response).to have_http_status updated
        expect { bucket.reload }.to raise_error
        expect { contribution.reload }.to raise_error
      end
    end

    context "admin" do
      it "deletes a bucket (and associated dependencies" do
        contribution
        admin = create(:user)
        group.add_admin(admin)

        admin_request_headers = {
          "X-User-Token" => admin.access_token,
          "X-User-Email" => admin.email
        }.merge(logged_out_headers)

        delete "/buckets/#{bucket.id}", {}, admin_request_headers

        expect(response).to have_http_status updated
        expect { bucket.reload }.to raise_error
        expect { contribution.reload }.to raise_error        
      end
    end

    context "not owner of bucket" do
      it "does not delete bucket" do
        contribution
        non_owner = create(:user)

        non_owner_request_headers = {
          "X-User-Token" => non_owner.access_token,
          "X-User-Email" => non_owner.email
        }.merge(logged_out_headers)

        delete "/buckets/#{bucket.id}", {}, non_owner_request_headers

        expect(response).to have_http_status forbidden
        expect { bucket.reload }.not_to raise_error
        expect { contribution.reload }.not_to raise_error
      end
    end
  end
end
