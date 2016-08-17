require 'rails_helper'

RSpec.describe AllocationsController, type: :controller do
  let(:valid_csv) { fixture_file_upload('bulk-allocation-csvs/test-csv.csv', 'text/csv') }
  let(:csv_with_fucked_up_email_addresses) { fixture_file_upload('bulk-allocation-csvs/test-csv-fucked-up-email-addresses.csv', 'text/csv') }
  let(:csv_with_non_number_allocations) { fixture_file_upload('bulk-allocation-csvs/test-csv-non-number-allocations.csv', 'text/csv') }
  let(:csv_with_too_many_columns) { fixture_file_upload('bulk-allocation-csvs/test-csv-too-many-columns.csv', 'text/csv') }
  let(:totally_fucked_csv) { fixture_file_upload('bulk-allocation-csvs/totally-fucked-csv.csv', 'text/csv') }
  let(:empty_csv) { fixture_file_upload('bulk-allocation-csvs/empty-csv.csv', 'text/csv') }
  let(:enormous_debt_csv) { fixture_file_upload('bulk-allocation-csvs/enormous-debt-csv.csv', 'text/csv') }
  let(:csv_with_semicolons) { fixture_file_upload('bulk-allocation-csvs/csv-with-semicolons.csv', 'text/csv') }
  let(:duplicate_emails_csv) { fixture_file_upload('bulk-allocation-csvs/duplicate-emails-csv.csv', 'text/csv') }

  describe "#upload_review" do
    context "user is group admin" do
      before do
        @membership = make_user_group_admin
        request.headers.merge!(user.create_new_auth_token)
      end

      context "valid csv" do
        before do
          @group = @membership.group
          @person0 = create(:user, email: "person0@example.com", name: "Person0")
          create(:membership, member: @person0, group: @group)
          post :upload_review, {group_id: @membership.group_id, csv: valid_csv}
        end

        it "returns http status 'ok'" do
          expect(response).to have_http_status(:ok)
        end

        it "returns review data as json" do
          expect(parsed(response)).to eq({
            "data" => [
              {"id" => @person0.id, "email" => "person0@example.com", "name" => "Person0", "allocation_amount" => "0.01", "new_member" => false},
              {"id" => "",          "email" => "person1@example.com", "name" => ""       , "allocation_amount" => "0.10", "new_member" => true },
              {"id" => "",          "email" => "person2@example.com", "name" => ""       , "allocation_amount" => "1.00", "new_member" => true }
            ]
          })
        end
      end

      context "csv uses semicolons as column separators instead of commas" do
        before do
          @group = @membership.group
          @person0 = create(:user, email: "person0@example.com", name: "Person0")
          create(:membership, member: @person0, group: @group)
          post :upload_review, {group_id: @membership.group_id, csv: csv_with_semicolons}
        end

        it "returns http status 'ok'" do
          expect(response).to have_http_status(:ok)
        end

        it "reformats the csv, parses it normally, and returns review data as json" do
          expect(parsed(response)).to eq({
            "data" => [
              {"id" => @person0.id, "email" => "person0@example.com", "name" => "Person0", "allocation_amount" => "0.01", "new_member" => false},
              {"id" => "",          "email" => "person1@example.com", "name" => ""       , "allocation_amount" => "0.10", "new_member" => true },
              {"id" => "",          "email" => "person2@example.com", "name" => ""       , "allocation_amount" => "1.00", "new_member" => true }
            ]
          })
        end
      end

      context "csv has fucked up email addresses" do
        it "returns http status 'unprocessable'" do
          post :upload_review, {group_id: @membership.group_id, csv: csv_with_fucked_up_email_addresses}
          expect(response).to have_http_status(422)
        end
      end

      context "csv has non-number allocation amounts" do
        it "returns http status 'unprocessable'" do
          post :upload_review, {group_id: @membership.group_id, csv: csv_with_non_number_allocations}
          expect(response).to have_http_status(422)
        end
      end

      context "csv has more than two columns" do
        it "returns http status 'unprocessable'" do
          post :upload_review, {group_id: @membership.group_id, csv: csv_with_too_many_columns}
          expect(response).to have_http_status(422)
        end
      end

      context "csv is empty" do
        it "returns http status 'unprocessable'" do
          post :upload_review, {group_id: @membership.group_id, csv: empty_csv}
          expect(response).to have_http_status(422)
        end
      end

      context "csv contains values that would overdraft members" do
        it "return http status 'unprocessable'" do
          post :upload_review, {group_id: @membership.group_id, csv: enormous_debt_csv}
          expect(response).to have_http_status(422)
        end
      end

      context "csv contains duplicate email addresses" do
        before do
          post :upload_review, {group_id: @membership.group_id, csv: duplicate_emails_csv}
        end

        it "returns http status 'unprocessable'" do
          expect(response).to have_http_status(422)
        end

        it "returns an error for each duplicate" do
          expect(parsed(response)["errors"].length).to eq(2)
        end
      end
    end

    context "user is not group admin" do
      before do
        membership = make_user_group_member
        request.headers.merge!(user.create_new_auth_token)
        post :upload_review, {group_id: membership.group_id, csv: valid_csv}
      end

      it "returns http status 'forbidden'" do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "user not logged in" do
      before do
        membership = make_user_group_member
        post :upload_review, {group_id: membership.group_id, csv: valid_csv}
      end

      it "returns http status 'unauthorized'" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "#create" do
    context "user is group admin" do
      before do
        @membership = make_user_group_admin
        request.headers.merge!(user.create_new_auth_token)
      end

      context "valid params" do
        before do
          valid_params = {
            allocation: {
              group_id: @membership.group.id,
              user_id: @membership.member.id,
              amount: 420
            }
          }
          post :create, valid_params
          @found_allocation = Allocation.find_by(valid_params[:allocation])
        end

        it "creates allocation with specified params" do
          expect(@found_allocation).to be_truthy
        end

        it "returns allocation as json" do
          expect(parsed(response)["allocations"][0]["id"]).to eq(@found_allocation.id)
        end

        it "returns http status 'created'" do
          expect(response).to have_http_status(:created)
        end
      end

      context "invalid params" do
        before do
          invalid_params = {
            allocation: {
              group_id: @membership.group.id,
              user_id: @membership.member.id,
              amount: 0
            }
          }
          post :create, invalid_params
          @found_allocation = Allocation.find_by(invalid_params[:allocation])
        end

        it "does not create an allocation" do
          expect(@found_allocation).to be_nil
        end

        it "returns http status 400" do
          expect(response).to have_http_status(400)
        end
      end
    end

    context "user is not group admin" do
      before do
        membership = make_user_group_member
        request.headers.merge!(user.create_new_auth_token)
        valid_params = {
          allocation: {
            group_id: membership.group.id,
            user_id: membership.member.id,
            amount: 420
          }
        }
        post :create, valid_params
        @found_allocation = Allocation.find_by(valid_params[:allocation])
      end

      it "does not create an allocation" do
        expect(@found_allocation).to be_nil
      end

      it "returns http status 'forbidden'" do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "user not logged in" do
      it "returns http status 'unauthorized'" do
        membership = make_user_group_member
        post :create, {membership_id: membership.id, amount: 420}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
