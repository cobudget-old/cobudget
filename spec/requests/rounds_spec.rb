require 'rails_helper'

describe "Rounds" do
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  let(:make_user_group_member) { FactoryGirl.create(:membership, group: group, user: user) }
  let(:make_user_group_admin) { FactoryGirl.create(:membership, group: group, user: user, is_admin: true) }

  describe "POST /rounds" do
    let(:time_now) { Time.new(2007,11,1,15,25,0, "+09:00") }
    let(:round_params) { {
      round: {
        group_id: group.id,
        name: "November Surplus",
        starts_at: time_now,
        ends_at: time_now + 3.days
      }
    }.to_json }

    context 'admin' do
      before { make_user_group_admin }
      it "creates a round" do
        post "/rounds", round_params, request_headers
        round = Round.first

        expect(response.status).to eq created
        expect(round.name).to eq "November Surplus"
        expect(round.starts_at).to eq time_now
        expect(round.ends_at).to eq time_now + 3.days
      end
    end

    context 'member' do
      before { make_user_group_member }
      it "cannot create a round" do
        post "/rounds", round_params, request_headers
        round = Round.first

        expect(response.status).to eq forbidden
        expect(round).to eq nil
      end
    end
  end
end
