class RoundService
  def self.open_for_proposals(round:, admin:)
    if round.save
      SendInvitationsToProposeJob.perform_later(admin, round)
      SendInvitationsToContributeJob.set(wait_until: round.starts_at).perform_later(admin, round)
      SendRoundClosedNotificationsJob.set(wait_until: round.ends_at).perform_later(admin, round)
    end
  end

  def self.open_for_contributions(round:, admin:)
    round.starts_at = Time.zone.now
    if round.save
      SendInvitationsToContributeJob.perform_later(admin, round)
      SendRoundClosedNotificationsJob.set(wait_until: round.ends_at).perform_later(admin, round)
    end
  end
end