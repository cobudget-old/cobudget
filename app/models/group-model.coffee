null

### @ngInject ###
global.cobudgetApp.factory 'GroupModel', (BaseModel) ->
  class GroupModel extends BaseModel
    @singular: 'group'
    @plural: 'groups'
    @serializableAttributes: ['name', 'currencyCode', 'initialized']

    relationships: ->
      @hasMany 'buckets'
      @hasMany 'allocations'
      @hasMany 'memberships', sortBy: 'createdAt', sortDesc: false

    draftBuckets: ->
      @getActiveBuckets('draft', 'createdAt')

    liveBuckets: ->
      @getActiveBuckets('live', 'liveAt')

    fundedBuckets: ->
      @getActiveBuckets('funded', 'fundedAt')

    balanceOverTime: ->
      paidBuckets = _.filter @buckets(), (bucket) ->
        bucket.isPaid() 
      
      paymentsByDate = _.map paidBuckets, (bucket) ->
        {
          'date': bucket.paidAt
          'amount': bucket.totalContributions
        }
      console.log(paymentsByDate)

      allocationsByDate = _.map @allocations(), (allocation) -> 
        {
          'date': allocation.createdAt
          'amount': allocation.amount + balance
        }
      console.log(allocationsByDate)

      allTransactions = paymentsByDate.concat allocationsByDate

      transactionsByDate = _.sortBy allTransactions, (tx) ->
        tx.date

      balance = 0
      balanceByDate = _.map transactionsByDate, (tx) ->
        balance += tx.amount
        { 
          'date' : tx.date
          'balance' : tx.amount + balance
        }
      
      dateList = _.map balanceByDate, (tx) ->
        tx.date
      
      balanceList = _.map balanceByDate, (tx) ->
        tx.balance
      
      {'dates': dateList.toString(), 'balances': balanceList.toString()}


    archivedBuckets: ->
      buckets = _.filter @buckets(), (bucket) ->
        bucket.isArchived()
      sortedBuckets = _.sortBy buckets, (bucket) ->
        bucket.archivedAt
      sortedBuckets.reverse()

    pendingMemberships: ->
      _.filter @memberships(), (membership) ->
        membership.isPending()

    settledMemberships: ->
      _.filter @memberships(), (membership) ->
        !membership.isPending()

    # hasManyThrough doesn't yet exist quite yet
    members: ->
      _.map @memberships(), (membership) ->
        membership.member()

    membershipFor: (member) ->
      _.first _.filter @memberships(), (membership) ->
        membership.memberId == member.id

    # private
    filterActiveBucketsByStatus: (status) ->
      _.filter @buckets(), (bucket) ->
        bucket.status == status && !bucket.isArchived()

    getActiveBuckets: (status, datePropToSortBy) ->
      filteredBuckets = @filterActiveBucketsByStatus(status)
      _.sortBy filteredBuckets, (bucket) ->
        bucket[datePropToSortBy].format()
      .reverse()
