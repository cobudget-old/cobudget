class RecentActivityService
  attr_accessor :comments_on_bucket_you_participated_in,
                :comments_on_buckets_user_authored,
                :contributions_to_live_buckets_user_authored,
                :funded_buckets_user_authored,
                :contributions_to_live_buckets_user_participated_in,
                :new_funded_buckets,
                :new_draft_buckets,
                :new_live_buckets,
                :time_range,
                :buckets_user_participated_in,
                :buckets_user_commented_on_ids,
                :buckets_user_contributed_to_ids,
                :user_buckets,
                :user_group_buckets,
                :users_active_groups,
                :user,
                :personal_activity,
                :activity

  def initialize(user:, time_range:)
    @user = user
    @time_range = time_range
    @activity = {}
    @personal_activity = {}
  end

  def personal_activity_for_group(group)
    personal_activity[group] ||= {
      contributions_to_live_buckets_user_authored:        collection_scoped_to_group(collection: contributions_to_live_buckets_user_authored,        group: group),
      funded_buckets_user_authored:                       collection_scoped_to_group(collection: funded_buckets_user_authored,                       group: group),
      comments_on_buckets_user_authored:                  collection_scoped_to_group(collection: comments_on_buckets_user_authored,                  group: group),
      comments_on_buckets_user_participated_in:           collection_scoped_to_group(collection: comments_on_buckets_user_participated_in,           group: group),
      contributions_to_live_buckets_user_participated_in: collection_scoped_to_group(collection: contributions_to_live_buckets_user_participated_in, group: group)
    }
  end

  def personal_activity_present_for_group?(group)
    personal_activity_for_group(group).values.compact.any?
  end

  def personal_activity_present?
    user.active_groups.any? { |group| personal_activity_present_for_group?(group) }
  end

  def for_group(group)
    activity[group] ||= {
      contributions_to_live_buckets_user_authored:        collection_scoped_to_group(collection: contributions_to_live_buckets_user_authored,        group: group),
      funded_buckets_user_authored:                       collection_scoped_to_group(collection: funded_buckets_user_authored,                       group: group),
      comments_on_buckets_user_authored:                  collection_scoped_to_group(collection: comments_on_buckets_user_authored,                  group: group),
      comments_on_buckets_user_participated_in:           collection_scoped_to_group(collection: comments_on_buckets_user_participated_in,           group: group),
      new_live_buckets:                                   collection_scoped_to_group(collection: new_live_buckets,                                   group: group),
      new_draft_buckets:                                  collection_scoped_to_group(collection: new_draft_buckets,                                  group: group),
      contributions_to_live_buckets_user_participated_in: collection_scoped_to_group(collection: contributions_to_live_buckets_user_participated_in, group: group),
      new_funded_buckets:                                 collection_scoped_to_group(collection: new_funded_buckets,                                 group: group)
    }
  end

  def is_present_for_group?(group)
    for_group(group).values.compact.any?
  end

  def is_present?
    user.active_groups.any? { |group| is_present_for_group?(group) }
  end

  private
    def collection_scoped_to_group(collection:, group:)
      return nil unless collection && collection.any?
      scoped_collection =
        if collection.table_name == "comments" || collection.table_name == "contributions"
          collection.joins(:bucket).where(buckets: {group_id: group.id})
        elsif collection.table_name == "buckets"
          collection.where(group: group)
        end
      scoped_collection if scoped_collection && scoped_collection.any?
    end

    def contributions_to_live_buckets_user_authored
      contributions_to_live_buckets_user_authored ||= Contribution.where(
        created_at: time_range,
        bucket: user_buckets.where(funded_at: nil)
      )
    end

    def funded_buckets_user_authored
      funded_buckets_user_authored ||= user_buckets.where(funded_at: time_range)
    end

    def comments_on_buckets_user_authored
      comments_on_buckets_user_authored ||= Comment.where(bucket: user_buckets, created_at: time_range)
    end

    def comments_on_buckets_user_participated_in
      comments_on_buckets_user_participated_in ||= Comment.where(bucket: buckets_user_participated_in, created_at: time_range)
    end

    def new_live_buckets
      new_live_buckets ||= user_group_buckets.where(status: "live", live_at: time_range)
    end

    def new_draft_buckets
      new_draft_buckets ||= user_group_buckets.where(status: "draft", created_at: time_range)
    end

    def contributions_to_live_buckets_user_participated_in
      contributions_to_live_buckets_user_participated_in ||= Contribution.where(
        created_at: time_range,
        bucket: buckets_user_participated_in.where(funded_at: nil)
      )
    end

    def new_funded_buckets
      new_funded_buckets ||= user_group_buckets.where(status: "funded", funded_at: time_range)
                                               .where.not(user: user)
    end

    ###############################################################

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
