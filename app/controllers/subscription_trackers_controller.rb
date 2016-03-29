class SubscriptionTrackersController < AuthenticatedController
  api :POST, '/subscription_trackers', 'updates users email settings'
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
        :comments_on_buckets_user_authored,
        :comments_on_buckets_user_participated_in,
        :new_draft_buckets,
        :new_live_buckets,
        :new_funded_buckets,
        :contributions_to_live_buckets_user_authored,
        :contributions_to_live_buckets_user_participated_in,
        :funded_buckets_user_authored,
        :notification_frequency
      )
    end
end
