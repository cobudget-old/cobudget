null

### @ngInject ###
global.cobudgetApp.factory 'GroupModel', (BaseModel) ->
  class GroupModel extends BaseModel
    @singular: 'group'
    @plural: 'groups'

    setupViews: ->
      @setupView 'buckets', 'createdAt', true
      @setupView 'memberships', 'createdAt', true

    publishedBuckets: ->
      _.filter @bucketsView.data(), (bucket) ->
        bucket.published

    draftBuckets: ->
      _.filter @bucketsView.data(), (bucket) ->
        !bucket.published

    memberships: ->
      @membershipsView.data()

    members: ->
      _.map @memberships(), (membership) ->
        membership.member()
                      
    # personalFunds: ->

    # totalFunds: ->