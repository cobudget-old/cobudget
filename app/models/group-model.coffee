null

# @ngInject
global.cobudgetApp.factory 'GroupModel', (BaseModel) ->
  class GroupModel extends BaseModel
    @singular: 'group'
    @plural: 'groups'

    setupViews: ->
      @setupView 'buckets', 'createdAt', true # has_many ___, order, up/down
      @setupView 'users', 'name', true

    publishedBuckets: ->
      _.filter @bucketsView.data(), (bucket) ->
        bucket.published

    draftBuckets: ->
      _.filter @bucketsView.data(), (bucket) ->
        !bucket.published
        
    # personalFunds: ->

    # totalFunds: ->