null

### @ngInject ###
global.cobudgetApp.factory 'SubscriptionTrackerModel', (BaseModel) ->
  class SubscriptionTrackerModel extends BaseModel
    @singular: 'subscriptionTracker'
    @plural: 'subscriptionTrackers'

    @serializableAttributes: [
      'subscribedToEmailNotifications',
      'emailDigestDeliveryFrequency'
    ]

    relationships: ->
      @belongsTo 'user'
