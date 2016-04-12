class SubscriptionTrackersController < AuthenticatedController
  api :POST, '/subscription_trackers/update_email_settings', 'updates users email settings'
  def update_email_settings
    subscription_tracker = current_user.subscription_tracker
    subscription_tracker.update(subscription_tracker_params)
    if subscription_tracker.valid?
      render json: [subscription_tracker]
    else
      render json: subscription_tracker.errors.full_messages, status: 422
    end
  end

  private
    def subscription_tracker_params
      params.require(:subscription_tracker).permit(
        :subscribed_to_email_notifications,
        :email_digest_delivery_frequency
      )
    end
end
