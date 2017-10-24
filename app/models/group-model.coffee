null

### @ngInject ###
global.cobudgetApp.factory 'GroupModel', (BaseModel) ->
  class GroupModel extends BaseModel
    @singular: 'group'
    @plural: 'groups'
    @serializableAttributes: ['name', 'currencyCode', 'currencySymbol', 'initialized']

    relationships: ->
      @hasMany 'buckets'
      @hasMany 'allocations'
      @hasMany 'memberships', sortBy: 'createdAt', sortDesc: false

    draftBuckets: ->
      @getBuckets ((bucket) -> bucket.isIdea()), 'createdAt'

    liveBuckets: ->
      @getBuckets ((bucket) -> bucket.isFunding()), 'liveAt' 

    fundedBuckets: ->
      @getBuckets ((bucket) -> bucket.isFunded()), 'fundedAt'

    completedBuckets: ->
      @completeBuckets()

    allTransactions: ->
      paymentsByDate = _.map @completeBuckets(), (bucket) ->
        {
          'createdAt':bucket.paidAt
          'amount': bucket.totalContributions * -1
          'user': bucket.authorName
          'type': 'Complete'
        }

      allocationsByDate = _.map @allocations(), (allocation) ->
        {
          'createdAt': allocation.createdAt
          'amount': allocation.amount
          'user': allocation.user().name
          'type': 'Allocation'
        }

      transactions = paymentsByDate.concat allocationsByDate

      transactionsByDate = _.sortBy transactions, (tx) ->
        tx.createdAt

      runningBalance = 0
      for item in transactionsByDate
        runningBalance += item.amount
        item['balance'] = runningBalance

      transactionsByDate

    balanceOverTime: ->
      # balance over time combines money in (allocations) and money out (complete
      # buckets).
      paymentsByDate = _.map @completeBuckets(), (bucket) ->
        [
          bucket.paidAt, bucket.totalContributions * -1
        ]

      allocationsByDate = _.map @allocations(), (allocation) ->
        [
          allocation.createdAt, allocation.amount
        ]

      transactionsByDate = paymentsByDate.concat allocationsByDate

      # aggregate all txs for a given date
      aggregateByDate = {}
      for item in transactionsByDate
        d = moment(item[0]).format('l')
        aggregateByDate[d] = if not aggregateByDate[d] then 0 else aggregateByDate[d]
        aggregateByDate[d] += item[1]

      # turn it back into a list, and convert date back to unix epoch
      aggregateByDateList = []
      for _date, _amt of aggregateByDate
        unixDate = parseInt(moment(_date, "MM/DD/YYYY").format('x'))
        aggregateByDateList.push [unixDate, _amt]

      # sort it again...
      aggregateByDateSorted = _.sortBy aggregateByDateList, (tx) ->
        tx[0]

      # *then* convert it to balance
      balance = 0
      balanceByDate = _.map aggregateByDateSorted, (item) ->
        balance += item[1]
        [item[0], parseInt(balance)]

      balanceByDate

    completeBuckets: ->
      @getBuckets ((bucket) -> bucket.isComplete()), 'paidAt'

    cancelledBuckets: ->
      @getBuckets ((bucket) -> bucket.isCancelled()), 'archivedAt'

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
    filterBucketsByFunction: (fun) ->
      _.filter @buckets(), fun

    getBuckets: (fun, datePropToSortBy) ->
      filteredBuckets = @filterBucketsByFunction(fun)
      _.sortBy filteredBuckets, (bucket) ->
        bucket[datePropToSortBy].format()
      .reverse()

