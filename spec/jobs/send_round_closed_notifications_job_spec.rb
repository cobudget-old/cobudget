require 'rails_helper'

RSpec.describe SendRoundClosedNotificationsJob, type: :job do
  it "sends 'round is now closed' emails to all members of round" do
    round = create(:draft_round)
    admin = create(:user)
    group = round.group
    group.add_admin(admin)
    5.times { create(:membership, group: group) }
    members = group.members

    members.each do |member|
      mail_double = double('mail')
      expect(UserMailer).to receive(:round_closed_email).with(member, admin, round).and_return(mail_double)
      expect(mail_double).to receive(:deliver_later!)
    end

    SendRoundClosedNotificationsJob.perform_now(admin, round)
  end
end
