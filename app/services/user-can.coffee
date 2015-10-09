null

### @ngInject ###
global.cobudgetApp.factory 'UserCan', (Toast, $location, $q, Records) ->
  new class UserCan

    viewGroup: (group) ->
      validMemberships = Records.memberships.find({
        groupId: group.id,
        memberId: global.cobudgetApp.currentUserId
      })
      validMemberships.length == 1

    viewBucket: (bucket) ->
      @viewGroup(bucket.group())