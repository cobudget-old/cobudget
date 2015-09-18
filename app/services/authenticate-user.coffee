null

### @ngInject ###
global.cobudgetApp.factory 'AuthenticateUser', (Records, ipCookie, Toast, $location) ->
  (callback) ->
    if ipCookie('currentUserId')
      Records.memberships.fetchMyMemberships().then ->
        callback()
    else
      ipCookie('initialRequestPath', $location.path())
      Toast.show('You must sign in to continue')
      $location.path('/')

