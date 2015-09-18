null

### @ngInject ###
global.cobudgetApp.factory 'AuthenticateUser', (Records, ipCookie, Toast, $location, $q) ->
  ->
    if ipCookie('currentUserId')
      Records.memberships.fetchMyMemberships()
    else
      ipCookie('initialRequestPath', $location.path())
      Toast.show('You must sign in to continue')
      $location.path('/')

