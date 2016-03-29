null

### @ngInject ###
global.cobudgetApp.factory 'SubscriptionTrackerModel', (BaseModel) ->
  class SubscriptionTrackerModel extends BaseModel
    @singular: 'subscriptionTracker'
    @plural: 'subscriptionTrackers'

    @serializableAttributes: [
      'commentsOnBucketsUserAuthored',
      'commentsOnBucketsUserParticipatedIn',
      'contributionsToLiveBucketsUserAuthored',
      'contributionsToLiveBucketsUserParticipatedIn',
      'fundedBucketsUserAuthored',
      'newDraftBuckets',
      'newLiveBuckets',
      'newFundedBuckets',
      'notificationFrequency'
    ]

    relationships: ->
      @belongsTo 'user'
