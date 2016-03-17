class RecentActivityService
  attr_accessor :comments_on_bucket_you_participated_in,
                :comments_on_users_buckets,
                :contributions_to_users_buckets,
                :contributions_to_buckets_user_participated_in,
                :users_buckets_fully_funded,
                :new_draft_buckets,
                :new_live_buckets,
                :other_buckets_fully_funded,
                :subscription_tracker,
                :time_range,
                :buckets_user_participated_in,
                :buckets_user_commented_on,
                :buckets_user_contributed_to,
                :user_buckets,
                :user_group_buckets,
                :users_active_groups,
                :user

  def initialize(user:)
    @user = user
  end

  def for_group(group)
    {
      comments_on_buckets_user_participated_in:      filtered_collection(collection: comments_on_buckets_user_participated_in, group: group),
      comments_on_users_buckets:                     filtered_collection(collection: comments_on_users_buckets, group: group),
      contributions_to_users_buckets:                filtered_collection(collection: contributions_to_users_buckets, group: group),
      contributions_to_buckets_user_participated_in: filtered_collection(collection: contributions_to_buckets_user_participated_in, group: group),
      users_buckets_fully_funded:                    filtered_collection(collection: users_buckets_fully_funded, group: group),
      new_draft_buckets:                             filtered_collection(collection: new_draft_buckets, group: group),
      new_live_buckets:                              filtered_collection(collection: new_live_buckets, group: group),
      other_buckets_fully_funded:                    filtered_collection(collection: other_buckets_fully_funded, group: group)
    }
  end

  def is_present?
    return false unless subscription_tracker.subscribed_to_any_activity?
    user.active_groups.map { |g| for_group(g).values }.flatten.compact.any?
  end

  private
    def filtered_collection(collection:, group:)
      return nil unless collection && collection.any?
      if collection.table_name == 'comments' || collection.table_name == 'contributions'
        collection.joins(:bucket).where(buckets: {group_id: group.id})
      elsif collection.table_name == 'buckets'
        collection.where(group: group)
      end
    end

    def comments_on_buckets_user_participated_in
      if subscription_tracker.comment_on_bucket_you_participated_in
        comments_on_buckets_user_participated_in ||= Comment.where(bucket: buckets_user_participated_in, created_at: time_range)
      end
    end

    def comments_on_users_buckets
      if subscription_tracker.comment_on_your_bucket
        comments_on_users_buckets ||= Comment.where(bucket: user_buckets, created_at: time_range)
      end
    end

    def contributions_to_users_buckets
      if subscription_tracker.funding_for_your_bucket
        contributions_to_users_buckets ||= Contribution.where(bucket: user_buckets, created_at: time_range)
      end
    end

    def contributions_to_buckets_user_participated_in
      if subscription_tracker.funding_for_a_bucket_you_participated_in
        contributions_to_buckets_user_participated_in ||= Contribution.where(bucket: buckets_user_participated_in, created_at: time_range)
      end
    end

    def users_buckets_fully_funded
      if subscription_tracker.your_bucket_fully_funded
        users_buckets_fully_funded ||= user_buckets.where(status: 'funded', funded_at: time_range)
      end
    end

    def new_draft_buckets
      if subscription_tracker.bucket_idea_created
        new_draft_buckets ||= user_group_buckets.where(status: 'draft', created_at: time_range)
      end
    end

    def new_live_buckets
      if subscription_tracker.bucket_started_funding
        new_live_buckets ||= user_group_buckets.where(status: 'live', live_at: time_range)
      end
    end

    def other_buckets_fully_funded
      if subscription_tracker.your_bucket_fully_funded
        other_buckets_fully_funded ||= user_group_buckets.where(status: 'funded', funded_at: time_range).where.not(user_id: user.id)
      end
    end

    def subscription_tracker
      subscription_tracker ||= user.subscription_tracker
    end

    def time_range
      time_range ||= (subscription_tracker.recent_activity_last_fetched_at..subscription_tracker.next_recent_activity_fetch_scheduled_at)
    end

    def buckets_user_participated_in
      buckets_user_participated_in ||= buckets_user_commented_on + buckets_user_contributed_to
    end

    def buckets_user_commented_on
      Bucket.joins(:comments).where(comments: {user: user})
    end

    def buckets_user_contributed_to
      Bucket.joins(:contributions).where(contributions: {user: user})
    end

    def user_buckets
      user_buckets ||= user.buckets
    end

    def user_group_buckets
      user_group_buckets ||= Bucket.where(group: user.active_groups)
    end
end
