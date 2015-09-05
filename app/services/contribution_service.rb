class ContributionService
  def self.send_project_received_funding_emails(contribution: contribution)
    funder = contribution.user
    project = contribution.bucket
    project_author = project.user

    if project.funded?
      UserMailer.notify_author_that_project_target_met(project: project).deliver_later
    elsif funder == project_author
      UserMailer.notify_author_that_project_received_funding(contribution: contribution).deliver_later
    end
  end
end