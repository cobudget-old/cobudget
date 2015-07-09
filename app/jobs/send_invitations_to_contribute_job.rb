class SendInvitationsToContributeJob < ActiveJob::Base
  queue_as :default

  def perform(inviter, group, round)
    round.allocations.each do |allocation|
      UserMailer.invite_to_contribute_email(allocation.user, inviter, group, round).deliver_later!
    end
  end
end

=begin

admin = User.find_by_name("Admin")
group = Group.first
round = Round.create(group_id: group.id, name: "test test test")
group.members.each do |member|
  round.allocations.create(user_id: member.id, amount: rand(1..420))
end

args = {
  starts_at: Time.zone.now + 10.seconds,
  ends_at: Time.zone.now + 20.seconds,
  admin: admin
}

round.publish_and_open_for_proposals!(args)

=end

=begin

admin = User.find_by_name("Admin")
group = Group.first
round = Round.create(group_id: group.id, name: "test test test")
group.members.each do |member|
  round.allocations.create(user_id: member.id, amount: rand(1..420))
end

args = {
  ends_at: Time.zone.now + 10.seconds,
  admin: admin
}

round.publish_and_open_for_contributions!(args)

=end