null

### @ngInject ###
global.cobudgetApp.factory 'GroupModel', (BaseModel) ->
  class GroupModel extends BaseModel
    @singular: 'group'
    @plural: 'groups'

    relationships: ->
      @hasMany 'buckets'
      @hasMany 'memberships'

    liveBuckets: ->
      _.filter @buckets(), (bucket) ->
        bucket.status == 'live'

    draftBuckets: ->
      _.filter @buckets(), (bucket) ->
        bucket.status == 'draft'

    # hasManyThrough doesn't yet exist quite yet
    members: ->
      _.map @memberships(), (membership) ->
        membership.member()

    membershipFor: (member) ->
      _.first _.filter @memberships(), (membership) ->
        membership.memberId == member.id