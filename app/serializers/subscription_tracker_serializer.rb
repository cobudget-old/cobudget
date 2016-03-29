class SubscriptionTrackerSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id,
             :comments_on_buckets_user_authored,
             :comments_on_buckets_user_participated_in,
             :new_draft_buckets,
             :new_live_buckets,
             :new_funded_buckets,
             :contributions_to_live_buckets_user_authored,
             :contributions_to_live_buckets_user_participated_in,
             :funded_buckets_user_authored,
             :notification_frequency
end
