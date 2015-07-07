require 'rails_helper'

describe "Rounds" do
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

  describe "PUT /rounds/:round_id" do
    let(:round) { FactoryGirl.create(:round, name: 'Goody', group: group) }
    let(:evil_group) { FactoryGirl.create(:group) }
    let(:round_params) { {
      round: {
        name: 'Sky Round',
        group_id: evil_group.id # this should be ignored
      }
    }.to_json }

    context 'admin' do
      before { make_user_group_admin }

      it "updates a round" do
        put "/rounds/#{round.id}", round_params, request_headers
        round.reload
        expect(response.status).to eq 204
        expect(round.name).to eq 'Sky Round'
        expect(round.group_id).not_to eq evil_group.id # don't let admin change group
      end
    end

    context 'member' do
      before { make_user_group_member }
      it "cannot update round" do
        put "/rounds/#{round.id}", round_params, request_headers
        round.reload
        expect(response.status).to eq 403
        expect(round.name).not_to eq 'Sky Round'
      end
    end
  end

  describe "DELETE /rounds/:round_id" do
    context 'admin' do
      before { make_user_group_admin }
      it "deletes a round (and associated dependencies)" do
        round
        bucket
        contribution
        allocation
        fixed_cost
        delete "/rounds/#{round.id}", {}, request_headers
        expect(response.status).to eq updated
        expect { round.reload }.to raise_error # deleted
        expect { bucket.reload }.to raise_error # deleted
        expect { allocation.reload }.to raise_error # deleted
        expect { contribution.reload }.to raise_error # deleted
        expect { fixed_cost.reload }.to raise_error # deleted
      end
    end

    context 'member' do
      before { make_user_group_member }

      it "cannot delete a round" do
        round
        delete "/rounds/#{round.id}", {}, request_headers
        expect(response.status).to eq forbidden
        expect { round.reload }.not_to raise_error # not deleted
      end
    end
  end

  describe "POST /rounds/:round_id/allocations/upload" do
    before do
      @upload_csv = fixture_file_upload("./spec/assets/test-csv.csv")
      @csv = CSV.read(@upload_csv)
      @csv.each { |email, allocation_amount| group.members << create(:user, email: email) }
      @round = create(:round, group: group)
    end

    context "admin" do
      before do
        make_user_group_admin
        post "/rounds/#{@round.id}/allocations/upload", { csv: @upload_csv }, request_headers
      end

      it "returns http status 'created'" do
        expect(response.status).to eq created
      end

      it "creates allocations for round from uploaded csv file" do
        expect(@round.allocations.length).to eq(@csv.length)
      end
    end

    context "member" do
      before do 
        make_user_group_member 
        post "/rounds/#{@round.id}/allocations/upload", { csv: @upload_csv }, request_headers
      end

      it "returns http status 'forbidden'" do
        expect(response.status).to eq forbidden
      end

      it "does not create any allocations" do
        expect(@round.allocations.length).to eq(0)
      end
    end
  end

  describe "PUT '/rounds/:round_id/publish" do
    context "admin" do
      before do
        make_user_group_admin
        @admin = user
        @round = create(:round, group: group)
        create(:allocation, user: @admin, round: @round)
      end

      context "if skip_proposals: false" do
        context "and valid params" do 
          before do
            @valid_params = {
              round: {
                skip_proposals: "false",
                starts_at: Time.zone.now + 1.days, 
                ends_at: Time.zone.now + 4.days
              }
            }.to_json
            put "/rounds/#{@round.id}/publish", @valid_params, request_headers
            @round.reload
          end

          it "the round is published" do 
            expect(@round.published).to eq(true)
          end

          it "the round enters proposal mode" do
            expect(@round.mode).to eq("proposal")
          end

          it "returns http status 'updated'" do
            expect(response.status).to eq updated
          end
        end

        context "and invalid params" do 
          before do
            @invalid_params = {
              round: {
                skip_proposals: "false"
              }
            }.to_json
            put "/rounds/#{@round.id}/publish", @invalid_params, request_headers
          end

          it "returns http status 'unprocessable'" do
            expect(response.status).to eq unprocessable
          end

          it "returns errors" do
            expect(response.body).to include("errors")
          end
        end
      end

      context "if skip_proposals: true" do
        context "and valid params" do
          before do
            @valid_params = {
              round: {
                skip_proposals: "true",
                ends_at: Time.zone.now + 4.days
              }
            }.to_json
            put "/rounds/#{@round.id}/publish", @valid_params, request_headers
            @round.reload
          end

          it "the round is published" do
            expect(@round.published).to eq(true)
          end

          it "the round is in 'contribution' mode" do
            expect(@round.mode).to eq('contribution')
          end

          it "returns http status 'updated'" do
            expect(response.status).to eq updated
          end
        end

        context "and invalid params" do
          before do
            @invalid_params = {
              round: {
                skip_proposals: "true"
              }
            }.to_json
            put "/rounds/#{@round.id}/publish", @invalid_params, request_headers
            @round.reload
          end          

          it "the round is not published" do
            expect(@round.published).to eq(false)
          end

          it "returns http status 'unprocessable'" do
            expect(response.status).to eq unprocessable
          end

          it "returns errors" do
            expect(response.body).to include("errors")
          end
        end
      end
    end

    context "member" do
      before do 
        @round = create(:draft_round)
        make_user_group_member 
      end

      it "returns http status 'forbidden'" do
        put "/rounds/#{@round.id}/publish", {}, request_headers
        expect(response.status).to eq forbidden
      end

      it "round is not published" do
        expect(@round).not_to receive(:publish!)
        put "/rounds/#{@round.id}/publish", {}, request_headers          
      end      
    end
  end
end
