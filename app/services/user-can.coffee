null

### @ngInject ###
global.cobudgetApp.factory 'UserCan', (CurrentUser, $location, $q, Records, Toast) ->
  new class UserCan
    viewGroup: (group) ->
      validMemberships = Records.memberships.find({
        groupId: group.id,
        memberId: global.cobudgetApp.currentUserId
      })
      validMemberships.length == 1

    viewBucket: (bucket) ->
      @viewGroup(bucket.group())

    editBucket: (bucket) ->
      isBucketAuthor = bucket.userId == global.cobudgetApp.currentUserId
      isBucketAuthor || CurrentUser().isAdminOf(bucket.group())

    viewAdminPanel: ->
      validMemberships = Records.memberships.find({
        memberId: global.cobudgetApp.currentUserId,
        isAdmin: true
      })
      validMemberships.length > 0

    changeEmailSettings: ->
      CurrentUser().isConfirmed()

    manageFundsForGroup: (group) ->
      CurrentUser().isAdminOf(group)
