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
      @getBuckets('draft', 'createdAt')

    liveBuckets: ->
      @getBuckets('live', 'liveAt')

    fundedBuckets: ->
      @getBuckets('funded', 'fundedAt')

    # hasManyThrough doesn't yet exist quite yet
    members: ->
      _.map @memberships(), (membership) ->
        membership.member()

    membershipFor: (member) ->
      _.first _.filter @memberships(), (membership) ->
        membership.memberId == member.id

    # private

    filterBucketsByStatus: (status) ->
      _.filter @buckets(), (bucket) ->
        bucket.status == status

    getBuckets: (status, datePropToSortBy) ->
      filteredBuckets = @filterBucketsByStatus(status)
      _.sortBy filteredBuckets, (bucket) ->
        bucket[datePropToSortBy].format()
      .reverse()
