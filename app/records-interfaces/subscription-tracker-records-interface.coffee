global.cobudgetApp.factory 'SubscriptionTrackerRecordsInterface', (config, BaseRecordsInterface, $q, SubscriptionTrackerModel) ->
  class SubscriptionTrackerRecordsInterface extends BaseRecordsInterface
    model: SubscriptionTrackerModel
    constructor: (recordStore) ->
      @baseConstructor recordStore
      @remote.apiPrefix = config.apiPrefix

    updateEmailSettings: (subscriptionTracker) ->
      params = _.pick subscriptionTracker, [
        'subscribedToEmailNotifications',
        'emailDigestDeliveryFrequency'
      ]
      @remote.post('update_email_settings', { subscription_tracker: morph.toSnake(params) })
