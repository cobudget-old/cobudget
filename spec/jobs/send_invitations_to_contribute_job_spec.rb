require 'rails_helper'

RSpec.describe SendInvitationsToContributeJob, type: :job do

  it "sends emails to each member of the round with an allocation" do
    round = create(:draft_round)
    group = round.group
    admin = create(:user)
    group.add_admin(admin)
    5.times { create(:membership, group: group) }
    members = group.members
    members.each { |member| create(:allocation, user: member, round: round) }

    member_with_no_allocation = create(:user)
    create(:membership, group: group, member: member_with_no_allocation)
    group.reload

    round.allocations.each do |allocation|
      mail_double = double('mail')
      expect(UserMailer).to receive(:invite_to_contribute_email).with(allocation.user, admin, round).and_return(mail_double)
      expect(mail_double).to receive(:deliver_later)
    end

    expect(UserMailer).not_to receive(:invite_to_contribute_email).with(member_with_no_allocation, admin, round)
    
    SendInvitationsToContributeJob.perform_now(admin, round)
  end

end
