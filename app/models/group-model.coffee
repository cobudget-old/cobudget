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

    allTransactions: ->
      paymentsByDate = _.map @paidBuckets(), (bucket) ->
        {
          'createdAt':bucket.paidAt
          'amount': bucket.totalContributions * -1
          'user': bucket.authorName
          'type': 'Payout'
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
        item['balance'] = parseInt(runningBalance)

      transactionsByDate

    balanceOverTime: ->
      # balance over time combines money in (allocations) and money out (paid
      # buckets).
      paymentsByDate = _.map @paidBuckets(), (bucket) ->
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

    paidBuckets: ->
      _.filter @buckets(), (bucket) ->
        bucket.isPaid()

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
