null

### @ngInject ###
global.cobudgetApp.factory 'GroupModel', (BaseModel) ->
  class GroupModel extends BaseModel
    @singular: 'group'
    @plural: 'groups'
    @serializableAttributes: ['name', 'currencyCode', 'initialized']

    relationships: ->
      @hasMany 'buckets'
      @hasMany 'memberships', sortBy: 'createdAt', sortDesc: false

    draftBuckets: ->
      @getActiveBuckets('draft', 'createdAt')

    liveBuckets: ->
      @getActiveBuckets('live', 'liveAt')

    fundedBuckets: ->
      @getActiveBuckets('funded', 'fundedAt')

    archivedBuckets: ->
      buckets = _.filter @buckets(), (bucket) ->
        bucket.isArchived()
      sortedBuckets = _.sortBy buckets, (bucket) ->
        bucket.archivedAt
      sortedBuckets.reverse()

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
    filterActiveBucketsByStatus: (status) ->
      _.filter @buckets(), (bucket) ->
        bucket.status == status && !bucket.isArchived()

    getActiveBuckets: (status, datePropToSortBy) ->
      filteredBuckets = @filterActiveBucketsByStatus(status)
      _.sortBy filteredBuckets, (bucket) ->
        bucket[datePropToSortBy].format()
      .reverse()
