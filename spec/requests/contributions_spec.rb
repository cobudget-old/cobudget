require 'rails_helper'

describe "Buckets" do
  let(:contribution_user) { user }

  describe "POST /contributions" do
    let(:contribution_params) { {
      contribution: {
        bucket_id: round.id,
        user_id: contribution_user.id,
        amount_cents: 2500
      }
    }.to_json }

    it "user creates a contribution for themselves" do
      post "/contributions", contribution_params, request_headers
      contribution = Contribution.first
      expect(response.status).to eq 201
      expect(contribution.amount_cents).to eq 2500
      expect(contribution.user).to eq user
    end

    context 'trying to create a contribution for another user' do
      let(:contribution_user) { FactoryGirl.create(:user) }

      it "creates one for the current user instead" do
        post "/contributions", contribution_params, request_headers
        contribution = Contribution.first
        expect(contribution).not_to eq contribution_user
        expect(contribution.user).to eq user
      end
    end
  end

  describe "PUT /contributions" do
    let(:contribution_hash) {
      {
        bucket_id: round.id,
        user_id: contribution_user.id,
        amount_cents: 1500
      }
    }

    it "user updates a contribution for themselves" do
      contribution = Contribution.create contribution_hash

      contribution_hash['amount_cents'] = 4500

      put "/contributions/#{contribution.id}", {
        contribution: contribution_hash
      }.to_json, request_headers

      expect(response.status).to eq 204
      contribution = Contribution.first
      expect(contribution.amount_cents).to eq 4500
      expect(contribution.user).to eq user
    end
  end

  describe "DELETE /contributions/:id" do
    let(:contribution_hash) {
      {
        bucket_id: round.id,
        user_id: contribution_user.id,
        amount_cents: 2500
      }
    }

    it "user deletes a contribution" do
      contribution = Contribution.create contribution_hash
      delete "/contributions/#{contribution.id}", {}, request_headers
      expect(response.status).to eq 204
      expect(Contribution.count).to eq 0
    end
  end
end
