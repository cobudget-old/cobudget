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

    # openForFunding: ->
    #   @remote.postMember(@,'open_for_funding',{target: @target, })
      # Moment.format *****
      # @remote is an instance of the restful client        
      