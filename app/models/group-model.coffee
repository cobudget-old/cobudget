null

### @ngInject ###
global.cobudgetApp.factory 'GroupModel', (BaseModel) ->
  class GroupModel extends BaseModel
    @singular: 'group'
    @plural: 'groups'
    @serializableAttributes: ['name', 'currencyCode', 'currencySymbol', 'description', 'initialized', 'fundingFreeze']

    relationships: ->
      @hasMany 'buckets'
      @hasMany 'allocations'
      @hasMany 'memberships', sortBy: 'createdAt', sortDesc: false

    draftBuckets: ->
      @getBuckets ((bucket) -> bucket.isIdea()), 'createdAt'

    liveBuckets: ->
      @getBuckets ((bucket) -> bucket.isFunding()), 'liveAt' 

    fundedBuckets: ->
      @getBuckets ((bucket) -> bucket.isFunded()), 'fundedAt'

    completedBuckets: ->
      @completeBuckets()

    completeBuckets: ->
      @getBuckets ((bucket) -> bucket.isComplete()), 'paidAt'

    cancelledBuckets: ->
      @getBuckets ((bucket) -> bucket.isCancelled()), 'archivedAt'

    pendingMemberships: ->
      _.filter @memberships(), (membership) ->
        membership.isPending()

    settledMemberships: ->
      _.filter @memberships(), (membership) ->
        !membership.isPending()

    # hasManyThrough doesn't yet exist quite yet
    members: ->
      _.map @memberships(), (membership) ->
        membership.member()

    membershipFor: (member) ->
      _.first _.filter @memberships(), (membership) ->
        membership.memberId == member.id

    # private
    filterBucketsByFunction: (fun) ->
      _.filter @buckets(), fun

    getBuckets: (fun, datePropToSortBy) ->
      filteredBuckets = @filterBucketsByFunction(fun)
      _.sortBy filteredBuckets, (bucket) ->
        bucket[datePropToSortBy].format()
      .reverse()

