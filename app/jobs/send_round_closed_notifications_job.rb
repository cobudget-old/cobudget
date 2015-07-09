class SendRoundClosedNotificationsJob < ActiveJob::Base
  queue_as :default

  def perform(sender, group, round)
    group.members.each do |member|
      UserMailer.round_closed_email(member, sender, group, round).deliver_later!      
    end
  end
end
