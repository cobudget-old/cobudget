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
      @target - @totalContributions

    percentFunded: ->
      @totalContributions / @target * 100

    openForFunding: ->
      @remote.postMember(@id, 'open_for_funding')

    archive: ->
      @remote.postMember(@id, 'archive')

    hasComments: ->
      @numOfComments > 0

    contributionsByUser: (user) ->
      @recordStore.contributions.find(bucketId: @id, userId: user.id)

    amountContributedByUser: (user) ->
      _.sum @contributionsByUser(user), (contribution) ->
        contribution.amount

    amountContributedByOthers: (user) ->
      @totalContributions - @amountContributedByUser(user)

    percentContributedByOthers: (user) ->
      @amountContributedByOthers(user) / @target * 100

    percentContributedByUser: (user) ->
      @amountContributedByUser(user) / @target * 100

    isArchived: ->
      !!@archivedAt
