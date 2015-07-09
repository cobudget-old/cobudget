class SendInvitationsToProposeJob < ActiveJob::Base
  queue_as :default

  def perform(inviter, group, round)
    group.members.each { |member| UserMailer.invite_to_propose_email(member, inviter, group, round).deliver_later! }
  end
end
