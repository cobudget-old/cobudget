null

### @ngInject ###
global.cobudgetApp.factory 'UserCan', (Toast, $location, $q, Records) ->
  new class UserCan

    viewGroup: (groupId) ->
      validMemberships = Records.memberships.find({
        groupId: groupId,
        memberId: global.cobudgetApp.currentUserId
      })
      validMemberships.length == 1

    viewBucket: (bucketId) ->
      bucket = Records.buckets.find({
        id: bucketId  
      })[0]
      @viewGroup(bucket.groupId)