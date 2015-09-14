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
      @hasMany 'contributions', sortBy: 'createdAt', sortDesc: false
      @belongsTo 'group'
      @belongsTo 'author', from: 'users', by: 'userId'

    amountRemaining: ->
      # TODO: move totalContribution from server to client
      @target - @totalContributions

    percentFunded: ->
      @totalContributions / @target * 100

    openForFunding: ->
      @remote.postMember(@id,'open_for_funding', {target: @target, fundingClosesAt: @fundingClosesAt})

    hasComments: ->
      @comments().length > 0
    
    percentContributedByUser: (userId) ->
      contributions = _.select @contributions(), (contribution) ->
        contribution.userId == userId
      @sumContributionPercentages(contributions)

    percentNotContributedByUser: (userId) ->
      contributions = _.select @contributions(), (contribution) ->
        contribution.userId != userId
      @sumContributionPercentages(contributions)

    ### private methods ###
    
    sumContributionPercentages: (contributions) ->
      contributionAmounts = contributions.map (contribution) ->
        parseInt(contribution.amount)
      if contributionAmounts.length > 0
        totalAmountContributed = contributionAmounts.reduce (prev, curr) ->
          prev + curr
        totalAmountContributed / @target * 100
      else 
        0