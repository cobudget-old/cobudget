null

### @ngInject ###
global.cobudgetApp.run ($rootScope, Records, $q, $location, $auth, Toast) ->

  console.log('boot.coffee has loaded')

  membershipsLoadedDeferred = $q.defer()
  global.cobudgetApp.membershipsLoaded = membershipsLoadedDeferred.promise

  onAuthSuccess = (user) ->
    global.cobudgetApp.currentUserId = user.id
    Records.memberships.fetchMyMemberships().then (data) ->
      console.log('memberships loaded!')
      membershipsLoadedDeferred.resolve(data)

  $rootScope.$on 'auth:validation-success', (ev, user) ->
    console.log('auth:validation-success signal fired!')
    onAuthSuccess(user)

  $rootScope.$on 'auth:login-success', (ev, user) ->
    console.log('auth:login-success signal fired!')
    onAuthSuccess(user)
    global.cobudgetApp.membershipsLoaded.then (data) ->
      groupId = data.groups[0].id
      Toast.show('Welcome to Cobudget!')
      $location.path("/groups/#{groupId}")

  onAuthError = (user) ->
    console.log('auth error!')
    membershipsLoadedDeferred.reject()
    global.cobudgetApp.currentUserId = null
    Toast.show('Please log in to continue')
    $location.path('/')

  $rootScope.$on '$stateChangeError', (e, toState, toParams, fromState, fromParams, error) ->
    if error.reason == "unauthorized" && error.errors[0] == "No credentials"
      e.preventDefault()
      onAuthError()