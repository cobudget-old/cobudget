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
end
