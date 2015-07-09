require 'rails_helper'

RSpec.describe SendInvitationsToProposeJob, type: :job do
  it "send notification emails to everyone involved in the round" do
    round = create(:draft_round)
    admin = create(:user)
    group = round.group
    group.add_admin(admin)
    5.times { create(:membership, group: group) }
    members = group.members

    members.each do |member|
      mail_double = double('mail')
      expect(UserMailer).to receive(:invite_to_propose_email).with(member, admin, group, round).and_return(mail_double)
      expect(mail_double).to receive(:deliver_later!)
    end

    SendInvitationsToProposeJob.perform_now(admin, group, round)
  end
end
