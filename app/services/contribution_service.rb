class ContributionService
  def self.send_project_received_funding_emails(contribution: contribution)
    funder = contribution.user
    project_author = contribution.bucket.user
    unless funder == project_author
      UserMailer.notify_author_that_project_received_funding(contribution: contribution).deliver_later
    end
  end
end