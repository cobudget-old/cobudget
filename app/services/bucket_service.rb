class BucketService
  def self.send_project_live_emails(project: )
    members = project.group.memberships.select { |m| m.balance > 0 }
                                       .map { |m| m.member }
    members.each do |member|
      UserMailer.notify_member_that_project_is_live(project: project, member: member).deliver_later
    end
  end

  def self.send_project_funded_emails(project: )
    UserMailer.notify_author_that_project_is_funded(project: project).deliver_later
    project_author = project.user
    funders = project.contributions.to_a.uniq { |c| c.user_id }
                                        .map { |c| c.user }
                                        .reject { |funder| funder == project_author }
    funders.each do |funder|
      UserMailer.notify_funder_that_project_is_funded(project: project, funder: funder).deliver_later
    end
  end
end