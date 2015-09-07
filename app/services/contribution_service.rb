class ContributionService
  def self.send_project_received_contribution_emails(contribution: contribution)
    funder = contribution.user
    project = contribution.bucket
    project_author = project.user

    unless funder == project_author
      UserMailer.notify_author_that_project_received_contribution(contribution: contribution).deliver_later
    end

    if project.funded?
      BucketService.send_project_funded_emails(project: project)
    end
  end
end