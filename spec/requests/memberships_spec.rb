require 'rails_helper'

describe "Memberships" do
  describe "GET /groups/:group_id/memberships/" do
    it "displays memberships for a group" do
      membership1 = FactoryGirl.create(:membership, group_id: group.id)
      membership2 = FactoryGirl.create(:membership, group_id: group.id)

      get "/groups/#{group.id}/memberships/", {}, request_headers

      expect(response.status).to eq 200 # success

      body = JSON.parse(response.body)
      membernames = []
      membernames << body["memberships"][0]["member"]["name"]
      membernames << body["memberships"][1]["member"]["name"]
      expect(membernames).to include membership1.member.name
      expect(membernames).to include membership2.member.name
      expect(body["memberships"][0]["is_admin"]).to eq(false)
    end
  end

  describe "POST /memberships" do
    let(:new_member) { FactoryGirl.create(:user) }
    let(:existing_member) { FactoryGirl.create(:membership,
      group: group, member: FactoryGirl.create(:user)).member }
    let(:membership_params) { { membership: membership_details }.to_json }

    context 'admin' do
      let(:memberships) { group.reload.memberships }
      before { make_user_group_admin }

      context 'group_id is not present or invalid' do
        let(:membership_details) { {group_id: ''} }
        it 'returns error object' do
            post "/memberships", membership_params, request_headers
            body = JSON.parse(response.body)
            expect(response.status).to eq unprocessable
            expect(body['errors']['group_id']).to eq(["group not found"])
        end
      end
      context 'member.id is present' do
        let(:membership_details) { {
          group_id: group.id, member: { id: new_member.id } } }
        context 'user is not a member of the group' do
          it "creates membership" do
            post "/memberships", membership_params, request_headers

            expect(response.status).to eq created
            membership = memberships.where(member_id: new_member.id).first
          end
        end
        context 'user already a member of the group' do
          let(:membership_details) { {
            group_id: group.id, member: {
              id: existing_member.id
            } } }
          it "fails" do
            post "/memberships", membership_params, request_headers
            expect(response.status).to eq unprocessable
          end
        end
      end
      context 'email is present' do
        context 'user with email already exists' do
          context 'user is not a member of the group' do
            let(:membership_details) { {
              group_id: group.id, member: {
                email: new_member.email
              } } }
            it "creates membership" do
              post "/memberships", membership_params, request_headers
              expect(response.status).to eq created
              expect(memberships.where(member_id: new_member.id)).to exist
            end
          end
          context 'user is already a member of the group' do
            let(:membership_details) { {
              group_id: group.id, member: {
                email: existing_member.email
              } } }
            it "fails" do
              post "/memberships", membership_params, request_headers
              expect(response.status).to eq unprocessable
            end
          end
        end
        context 'user with email does not exist' do
          let(:new_member) {double(email: 'jonny@gonny.commy', name: 'Jo')}
          let(:membership_details) { { group_id: group.id, member: {
            email: new_member.email
          } } }
          context 'name is not present' do
            it 'creates user with email and uses first part of email for name' do
              expect{
                post "/memberships", membership_params, request_headers
              }.to change{User.count}.by(1)
              user = User.find_by(email: new_member.email) 
              expect(user.name).to eq('jonny')
            end
          end
          context 'name is present' do
            before { membership_details[:member][:name] = new_member.name }
            it 'creates user with name and email' do
              expect{
                post "/memberships", membership_params, request_headers
              }.to change{User.count}.by(1)
              user = User.find_by(email: new_member.email) 
              expect(user.name).to eq(new_member.name)
            end
          end
          it 'emails login details to user' do
            mail_double = double('mail')
            expect(UserMailer).to receive(:invite_email).and_return(mail_double)
            expect(mail_double).to receive(:deliver_later!)
            post "/memberships", membership_params, request_headers
          end
          it 'adds user to group' do
            post "/memberships", membership_params, request_headers
            user = User.find_by(email: new_member.email)
            expect(group.members.where(id: user.id)).to be_present
          end
        end
      end
      context 'member.id and email are present' do
        let(:membership_details) { { group_id: group.id,
          member: { id: new_member.id, email: 'newww@goo.poo' } } }
        it 'creates membership based on member_id' do
          post "/memberships", membership_params, request_headers
          expect(group.memberships.where(member_id: new_member.id)).to exist
        end
      end
      context 'is_admin is true' do
        let(:membership_details) { {
          group_id: group.id,
          member: { id: new_member.id },
          is_admin: true } }
        it 'create user as admin' do
          post "/memberships", membership_params, request_headers
          membership = group.memberships.where(member_id: new_member.id).first
          expect(membership.is_admin?).to eq(true)
        end
      end
    end

    context 'member' do
      let(:membership_details) { {
        group_id: group.id, member: { id: new_member.id } } }
      before { make_user_group_member }

      it "cannot create membership" do
        post "/memberships", membership_params, request_headers

        membership = Membership.last

        expect(response.status).to eq 403
        expect(membership.member).not_to eq new_member
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
