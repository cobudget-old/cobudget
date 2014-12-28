require 'rails_helper'

describe "Memberships" do
  describe "GET /groups/:group_id/memberships/" do
    it "displays memberships for a group" do
      membership1 = FactoryGirl.create(:membership, group_id: group.id)
      membership2 = FactoryGirl.create(:membership, group_id: group.id)

      get "/groups/#{group.id}/memberships/", {}, request_headers

      expect(response.status).to eq 200 # success

      body = JSON.parse(response.body)
      usernames = []
      usernames << body["memberships"][0]["user"]["name"]
      usernames << body["memberships"][1]["user"]["name"]
      expect(usernames).to include membership1.user.name
      expect(usernames).to include membership2.user.name
      expect(body["memberships"][0]["is_admin"]).to eq(false)
    end
  end

  describe "POST /memberships" do
    let(:new_member) { FactoryGirl.create(:user) }
    let(:membership_params) { {
      membership: {
        user_id: new_member.id,
        group_id: group.id
      }
    }.to_json }

    context 'admin' do
      before { make_user_group_admin }
      it "creates a membership" do
        post "/memberships", membership_params, request_headers

        membership = Membership.last

        expect(response.status).to eq 201
        expect(membership.user).to eq new_member
        expect(membership.group).to eq group
        expect(membership.is_admin?).to eq false
      end
    end

    context 'member' do
      before { make_user_group_member }
      it "cannot create membership" do
        post "/memberships", membership_params, request_headers

        membership = Membership.last

        expect(response.status).to eq 403
        expect(membership.user).not_to eq new_member
      end
    end
  end

  describe "PUT /memberships/:membership_id" do
    let(:membership) { FactoryGirl.create(:membership, group: group) }
    let(:evil_group) { FactoryGirl.create(:group) }
    let(:membership_params) { {
      membership: {
        is_admin: true,
        group_id: evil_group.id # this should be ignored
      }
    }.to_json }

    context 'admin' do
      before { make_user_group_admin }
      it "updates a membership" do
        put "/memberships/#{membership.id}", membership_params, request_headers
        membership.reload
        expect(response.status).to eq 204
        expect(membership.is_admin?).to eq true
        expect(membership.group).not_to eq evil_group # don't let admin be evil
      end
    end

    context 'member' do
      before { make_user_group_member }
      it "cannot update membership" do
        put "/memberships/#{membership.id}", membership_params, request_headers
        membership.reload
        expect(response.status).to eq 403
        expect(membership.is_admin?).to eq false
      end
    end
  end

  describe "DELETE /memberships/:membership_id" do
    let(:membership) { FactoryGirl.create(:membership, group: group) }

    context 'admin' do
      before { make_user_group_admin }
      it "deletes a membership" do
        delete "/memberships/#{membership.id}", {}, request_headers
        expect(response.status).to eq 204 # updated
        expect { membership.reload }.to raise_error # deleted
      end
    end

    context 'member' do
      before { @m = make_user_group_member }

      it "can delete their own membership" do
        delete "/memberships/#{@m.id}", {}, request_headers
        expect(response.status).to eq 204 # updated
        expect { @m.reload }.to raise_error # deleted
      end

      it "cannot delete another member's membership" do
        delete "/memberships/#{membership.id}", {}, request_headers
        expect(response.status).to eq 403 # forbidden
        expect { membership.reload }.not_to raise_error
      end
    end
  end
end
