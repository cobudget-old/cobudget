class RecentActivityService
  attr_accessor :comments_on_bucket_you_participated_in,
                :comments_on_buckets_user_authored,
                :contributions_to_live_buckets_user_authored,
                :funded_buckets_user_authored,
                :contributions_to_live_buckets_user_participated_in,
                :funded_buckets_user_participated_in,
                :new_draft_buckets,
                :new_live_buckets,
                :subscription_tracker,
                :time_range,
                :buckets_user_participated_in,
                :buckets_user_commented_on_ids,
                :buckets_user_contributed_to_ids,
                :user_buckets,
                :user_group_buckets,
                :users_active_groups,
                :user,
                :activity

  def initialize(user:)
    @user = user
    @activity = {}
  end

  def for_group(group)
    activity[group] ||= {
      contributions_to_live_buckets_user_authored:        filtered_collection(collection: contributions_to_live_buckets_user_authored,        group: group),
      funded_buckets_user_authored:                       filtered_collection(collection: funded_buckets_user_authored,                       group: group),
      comments_on_buckets_user_authored:                  filtered_collection(collection: comments_on_buckets_user_authored,                  group: group),
      comments_on_buckets_user_participated_in:           filtered_collection(collection: comments_on_buckets_user_participated_in,           group: group),
      new_live_buckets:                                   filtered_collection(collection: new_live_buckets,                                   group: group),
      new_draft_buckets:                                  filtered_collection(collection: new_draft_buckets,                                  group: group),
      contributions_to_live_buckets_user_participated_in: filtered_collection(collection: contributions_to_live_buckets_user_participated_in, group: group),
      funded_buckets_user_participated_in:                filtered_collection(collection: funded_buckets_user_participated_in,                group: group)
    }
  end

  def is_present?
    return false unless subscription_tracker.subscribed_to_any_activity?
    user.active_groups.map { |g| for_group(g).values }.flatten.compact.any?
  end

  private
    def filtered_collection(collection:, group:)
      return nil unless collection && collection.any?
      if collection.table_name == "comments" || collection.table_name == "contributions"
        collection.joins(:bucket).where(buckets: {group_id: group.id})
      elsif collection.table_name == "buckets"
        collection.where(group: group)
      end
    end

    def comments_on_buckets_user_participated_in
      if subscription_tracker.comment_on_bucket_you_participated_in
        comments_on_buckets_user_participated_in ||= Comment.where(bucket: buckets_user_participated_in, created_at: time_range)
      end
    end

    def comments_on_buckets_user_authored
      if subscription_tracker.comment_on_your_bucket
        comments_on_buckets_user_authored ||= Comment.where(bucket: user_buckets, created_at: time_range)
      end
    end

    def contributions_to_live_buckets_user_authored
      if subscription_tracker.funding_for_your_bucket
        contributions_to_live_buckets_user_authored ||= Contribution.where(
          created_at: time_range,
          bucket: user_buckets.where(funded_at: nil)
        )
      end
    end

    def funded_buckets_user_authored
      if subscription_tracker.your_bucket_fully_funded
        funded_buckets_user_authored ||= user_buckets.where(funded_at: time_range)
      end
    end

    def contributions_to_live_buckets_user_participated_in
      if subscription_tracker.funding_for_a_bucket_you_participated_in
        contributions_to_live_buckets_user_participated_in ||= Contribution.where(
          created_at: time_range,
          bucket: buckets_user_participated_in.where(funded_at: nil)
        )
      end
    end

    def new_draft_buckets
      if subscription_tracker.bucket_idea_created
        new_draft_buckets ||= user_group_buckets.where(status: "draft", created_at: time_range)
      end
    end

    def new_live_buckets
      if subscription_tracker.bucket_started_funding
        new_live_buckets ||= user_group_buckets.where(status: "live", live_at: time_range)
      end
    end

    def funded_buckets_user_participated_in
      if subscription_tracker.your_bucket_fully_funded
        funded_buckets_user_participated_in ||= buckets_user_participated_in.where(funded_at: time_range)
      end
    end

    ###############################################################

    def subscription_tracker
      subscription_tracker ||= user.subscription_tracker
    end

    def time_range
      time_range ||= subscription_tracker.next_fetch_time_range
    end

    def buckets_user_participated_in
      buckets_user_participated_in ||= Bucket.where(id: (buckets_user_commented_on_ids + buckets_user_contributed_to_ids).uniq)
    end

    def buckets_user_commented_on_ids
      Bucket.where.not(user: user).joins(:comments).where(comments: {user: user}).pluck(:id)
    end

    def buckets_user_contributed_to_ids
      Bucket.where.not(user: user).joins(:contributions).where(contributions: {user: user}).pluck(:id)
    end

    def user_buckets
      user_buckets ||= user.buckets
    end

    def user_group_buckets
      user_group_buckets ||= Bucket.where(group: user.active_groups)
    end
end
