class SendInvitationsToProposeJob < ActiveJob::Base
  queue_as :default

  def perform(inviter, round)
    round.group.members.each do |member| 
      UserMailer.invite_to_propose_email(member, inviter, round).deliver_later
    end
  end
end