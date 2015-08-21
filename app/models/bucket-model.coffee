null

### @ngInject ###
global.cobudgetApp.factory 'BucketModel', (BaseModel) ->
  class BucketModel extends BaseModel
    @singular: 'bucket'
    @plural: 'buckets'
    @indices: ['groupId', 'userId']

    relationships: ->
      @hasMany 'comments', sortBy: 'createdAt', sortDesc: true
      @belongsTo 'group'
      @belongsTo 'author', from: 'users', by: 'userId'

    amountRemaining: ->
      @target - @totalContributions

    percentFunded: ->
      @totalContributions / @target * 100

    openForFunding: ->
      @remote.postMember(@id,'open_for_funding', {target: @target, fundingClosesAt: @fundingClosesAt})
    
    # temp hack to allow post requests
    create: ->
      @remote.create
        bucket:
          description: @description
          name: @name 
          target: @target
          group_id: @groupId