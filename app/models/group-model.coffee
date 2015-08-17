null

### @ngInject ###
global.cobudgetApp.factory 'GroupModel', (BaseModel) ->
  class GroupModel extends BaseModel
    @singular: 'group'
    @plural: 'groups'

    relationships: ->
      @hasMany 'buckets'
      @hasMany 'memberships'

    publishedBuckets: ->
      _.filter @buckets(), (bucket) ->
        bucket.published

    draftBuckets: ->
      _.filter @buckets(), (bucket) ->
        !bucket.published

    # hasManyThrough doesn't yet exist quite yet
    members: ->
      _.map @memberships(), (membership) ->
        membership.member()
                      
    # personalFunds: ->

    # totalFunds: ->