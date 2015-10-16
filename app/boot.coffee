null

### @ngInject ###
global.cobudgetApp.run ($rootScope, Records, $q, $location, $auth, Toast) ->

  membershipsLoadedDeferred = $q.defer()
  global.cobudgetApp.membershipsLoaded = membershipsLoadedDeferred.promise

  $rootScope.$on 'auth:validation-success', (ev, user) ->
    global.cobudgetApp.currentUserId = user.id    
    Records.memberships.fetchMyMemberships().then ->
      membershipsLoadedDeferred.resolve()

  $rootScope.$on 'auth:login-success', (ev, user) ->
    global.cobudgetApp.currentUserId = user.id    
    Records.memberships.fetchMyMemberships().then (data) ->
      membershipsLoadedDeferred.resolve()
      groupId = data.groups[0].id
      $location.path("/groups/#{groupId}")
      Toast.show('Welcome to Cobudget!')

  $rootScope.$on '$stateChangeError', (e, toState, toParams, fromState, fromParams, error) ->
    if error.reason == "unauthorized" && error.errors[0] == "No credentials"
      e.preventDefault()
      global.cobudgetApp.currentUserId = null
      Toast.show('Please log in to continue')
      $location.path('/')
