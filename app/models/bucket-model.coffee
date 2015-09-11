null

### @ngInject ###
global.cobudgetApp.factory 'BucketModel', (BaseModel) ->
  class BucketModel extends BaseModel
    @singular: 'bucket'
    @plural: 'buckets'
    @indices: ['groupId', 'userId']
    @serializableAttributes: ['description', 'name', 'target', 'groupId']

    relationships: ->
      @hasMany 'comments', sortBy: 'createdAt', sortDesc: false
      @belongsTo 'group'
      @belongsTo 'author', from: 'users', by: 'userId'

    amountRemaining: ->
      @target - @totalContributions

    percentFunded: ->
      @totalContributions / @target * 100

    openForFunding: ->
      @remote.postMember(@id,'open_for_funding', {target: @target, fundingClosesAt: @fundingClosesAt})
  