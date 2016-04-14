class AnalyticsController < AuthenticatedController
  def report
    if current_user.is_super_admin
      render json: AnalyticsService.report
    else
      render nothing: true, status: 403
    end
  end
end
