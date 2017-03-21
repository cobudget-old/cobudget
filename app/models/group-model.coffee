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
          'amount': bucket.totalContributions * -1
        }

      allocationsByDate = _.map @allocations(), (allocation) ->
        {
          'date': allocation.createdAt
          'amount': allocation.amount
        }

      allTransactions = paymentsByDate.concat allocationsByDate

      transactionsByDate = _.sortBy allTransactions, (tx) ->
        tx.date

      balanceByDate = {}
      runningBalance = 0
      for item in transactionsByDate
        d = moment(item['date']).format('l')
        balanceByDate[d] = if balanceByDate[d] then balanceByDate[d] else runningBalance
        balanceByDate[d] += item.amount
        runningBalance += item.amount
      
      console.log('original')
      console.log(balanceByDate)

      currentDate = moment(transactionsByDate[0].date).startOf('day')
      endDate = moment().startOf('day')
      while (currentDate.add(1, 'days').diff(endDate) < 0)
        # if there were no transaction on this date, copy the balance from the
        # previous date.  there should always be a balance on the initial date
        if not balanceByDate[currentDate.format('l')]
          today = currentDate.format('l')
          yesterday = currentDate.clone().subtract(1, 'days').format('l')
          balanceByDate[today] = balanceByDate[yesterday] 
          console.log(balanceByDate[today])

      console.log('expanded')
      console.log(balanceByDate)
      
      balanceByDateList = []
      for k, v of balanceByDate
        balanceByDateList.push {'date': k, 'amount': v}
      
      balanceByDateSorted = _.sortBy balanceByDateList, (item) ->
        item.date

      dateList = _.map balanceByDateSorted, (item) ->
        item.date
        
      balanceList = _.map balanceByDateSorted, (item) ->
        item.amount

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
