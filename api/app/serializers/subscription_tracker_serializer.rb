class SubscriptionTrackerSerializer < ActiveModel::Serializer
  #embed :ids, include: true
  attributes :id, :subscribed_to_email_notifications, :email_digest_delivery_frequency
end
