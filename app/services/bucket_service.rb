class BucketService
  def self.send_project_live_emails(project: project)
    members = project.group.memberships.select { |m| m.balance > 0 }.map { |m| m.member }
    members.each do |member|
      UserMailer.notify_member_that_project_is_live(project: project, member: member).deliver_later
    end
  end
end