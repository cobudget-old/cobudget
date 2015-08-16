null

### @ngInject ###
global.cobudgetApp.factory 'BucketModel', (BaseModel) ->
  class BucketModel extends BaseModel
    @singular: 'bucket'
    @plural: 'buckets'
    @indices: ['groupId']
    @attributeNames = ['name', 'description', 'target', 'userId', 'groupId']

    setupViews: ->
      @setupView 'comments', 'createdAt', true

    amountRemaining: ->
      @target - @totalContributions

    percentFunded: ->
      @totalContributions / @target * 100

    comments: ->
      @commentsView.data()
