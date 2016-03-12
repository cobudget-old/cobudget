class UserService
  attr_reader :user

  def self.fetch_recent_activity_for(user:)
    @@user = user
    Hash[users_active_groups.map { |group| collated_activity_for_group(group) }]
  end

  def self.collated_activity_for_group(group)
    [group, {
      comments_on_buckets_user_participated_in: comments_on_buckets_user_participated_in.joins(:bucket).where(bucket: {group: group}),
      comments_on_users_buckets: comments_on_users_buckets.joins(:bucket).where(bucket: {group: group}),
      contributions_to_users_buckets: contributions_to_users_buckets.joins(:bucket).where(bucket: {group: group}),
      contributions_to_buckets_user_participated_in: contributions_to_buckets_user_participated_in.joins(:bucket).where(bucket: {group: group}),
      users_buckets_fully_funded: users_buckets_fully_funded.where(group: group),
      new_draft_buckets: new_draft_buckets.where(group: group),
      new_live_buckets: new_live_buckets.where(group: group),
      new_funded_buckets: new_funded_buckets.where(group: group)
    }]
  end

  def self.comments_on_buckets_user_participated_in
    @@comments_on_buckets_user_participated_in ||= Comment.where(bucket: buckets_user_participated_in, created_at: time_range)
  end

  def self.comments_on_users_buckets
    @@comments_on_users_buckets ||= Comment.where(bucket: user_buckets, created_at: time_range)
  end

  def self.contributions_to_users_buckets
    @@contributions_to_users_buckets ||= Contribution.where(bucket: user_buckets, created_at: time_range)
  end

  def self.contributions_to_buckets_user_participated_in
    @@contributions_to_buckets_user_participated_in ||= Contribution.where(bucket: buckets_user_participated_in, created_at: time_range)
  end

  def self.users_buckets_fully_funded
    @@users_buckets_fully_funded ||= user_buckets.where(status: 'funded', funded_at: time_range)
  end

  def self.new_draft_buckets
    @@new_draft_buckets ||= user_group_buckets.where(status: 'draft', created_at: time_range)
  end

  def self.new_live_buckets
    @@new_live_buckets ||= user_group_buckets.where(status: 'live', live_at: time_range)
  end

  def self.new_funded_buckets
    @@new_funded_buckets ||= user_group_buckets.where(status: 'funded', funded_at: time_range)
  end

  private
    def self.subscription_tracker
      @@subscription_tracker ||= user.subscription_tracker
    end

    def self.time_range
      @@time_range ||= (subscription_tracker.recent_activity_last_fetched_at..subscription_tracker.next_recent_activity_fetch_scheduled_at)
    end

    def self.buckets_user_participated_in
      @@buckets_user_participated_in ||= Bucket.joins(:comments, :contributions).where(
        comments: {user: user},
        contributions: {user: user}
      )
    end

    def self.user_buckets
      @@user_buckets ||= user.buckets
    end

    def self.user_group_buckets
      @@user_group_buckets ||= Bucket.where(group: users_active_groups)
    end

    def self.users_active_groups
      @@users_active_groups ||= Group.joins(:memberships).where(memberships: {member: user, archived_at: nil})
    end
end
