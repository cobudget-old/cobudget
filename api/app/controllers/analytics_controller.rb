require 'csv'

class AnalyticsController < AuthenticatedController
  def report
    if current_user.is_super_admin
      render json: AnalyticsService.report
    else
      render nothing: true, status: 403
    end
  end

  def group_report
    group = Group.find(params[:id])
    if current_user.is_member_of?(group)
      render json: GroupAnalyticsService.report(group)
    else
      render nothing: true, status: 403
    end
  end

  def admins
    respond_to do |format|
      memberships = Membership.where(is_admin: true).joins(:member).where.not(users: {confirmed_at: nil}).joins(:group)
      format.json do
        render json: memberships
      end

      format.csv do
        csv = MembershipService.generate_admin_csv(memberships: memberships)
        filename = "admin-contact-info-#{Time.now.utc.iso8601}"
        send_data csv, type: "text/csv; charset=utf-8", disposition: 'attachment', filename: filename
      end
    end
  end
end
