class BucketService
  def self.send_project_live_emails(project: )
    memberships = project.group.memberships
                                                    
    memberships.each do |membership|
      member = membership.member
      if membership.balance > 0
        UserMailer.notify_member_with_balance_that_project_is_live(project: project, member: member).deliver_later
      else
        UserMailer.notify_member_with_zero_balance_that_project_is_live(project: project, member: member).deliver_later
      end
    end
  end

  def self.send_project_funded_emails(project: )
    UserMailer.notify_author_that_project_is_funded(project: project).deliver_later
    project_author = project.user
    funders = project.contributions.to_a.uniq   { |c| c.user_id }
                                        .map    { |c| c.user }
                                        .reject { |funder| funder == project_author }
    funders.each do |funder|
      UserMailer.notify_funder_that_project_is_funded(project: project, funder: funder).deliver_later
    end
  end
end