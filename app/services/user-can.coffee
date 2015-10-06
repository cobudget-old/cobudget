null

### @ngInject ###
global.cobudgetApp.factory 'UserCan', (Toast, $location, $q, Records, ipCookie, AuthenticateUser) ->
  new class UserCan

    viewGroup: (groupId) ->
      validMemberships = Records.memberships.find({
        groupId: groupId,
        memberId: global.cobudgetApp.currentUserId
      })
      validMemberships.length == 1
