null

### @ngInject ###
global.cobudgetApp.factory 'FetchRecordsFor', (Toast, $q, Records, CurrentUser) ->
  new class FetchRecordsFor
    groupPage: (groupId) ->
      recordsFetched = $q.defer()

      records = {}

      # 0. get current user
      records.currentUser = CurrentUser()

      # 1. get accessible groups
      records.accessibleGroups = Records.memberships.find(groupId: groupId)

      # 2. get current group
      Records.groups.findOrFetchById(groupId).then (group) ->
        records.group = group

        # 3. get current membership
        records.currentMembership = records.group.membershipFor(records.currentUser)

        # 4. get group memberships
        membershipsFetched = Records.memberships.fetchByGroupId(records.group.id)

        # 5. get group buckets
        Records.buckets.fetchByGroupId(records.group.id).then ->
          buckets = records.group.buckets()
          if buckets.length > 0
            _.each buckets, (bucket) ->
              contributionsFetched = Records.contributions.fetchByBucketId(bucket.id)
              commentsFetched = Records.comments.fetchByBucketId(bucket.id)
              $q.all([contributionsFetched, commentsFetched, membershipsFetched]).then ->
                recordsFetched.resolve(records)

      recordsFetched.promise

    # bucketPage: (bucketId) ->


