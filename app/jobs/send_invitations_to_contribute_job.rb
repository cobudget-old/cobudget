class SendInvitationsToContributeJob < ActiveJob::Base
  queue_as :default

  def perform(inviter, group, round)
    round.allocations.each do |allocation|
      UserMailer.invite_to_contribute_email(allocation.user, inviter, group, round).deliver_later!
    end
  end
end