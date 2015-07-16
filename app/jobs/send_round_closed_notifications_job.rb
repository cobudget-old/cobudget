class SendRoundClosedNotificationsJob < ActiveJob::Base
  queue_as :default

  def perform(sender, round)
    round.group.members.each do |member|
      UserMailer.round_closed_email(member, sender, round).deliver_later      
    end
  end
end
