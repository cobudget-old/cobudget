null

### @ngInject ###
global.cobudgetApp.factory 'BucketModel', (BaseModel) ->
  class BucketModel extends BaseModel
    @singular: 'bucket'
    @plural: 'buckets'
    @indices: ['groupId']
    # @attributeNames = ['name', 'description', 'target', 'userId', 'groupId']

    relationships: ->
      @hasMany 'comments', sortBy: 'createdAt', sortDesc: true
      @belongsTo 'group'

    amountRemaining: ->
      @target - @totalContributions

    percentFunded: ->
      @totalContributions / @target * 100