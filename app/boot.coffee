null

### @ngInject ###
global.cobudgetApp.run ($rootScope, Records, $q, $location, AuthenticateUser, $auth, Toast) ->

  console.log('boot.coffee has loaded')

  userValidatedDeferred = $q.defer()
  global.cobudgetApp.userValidated = userValidatedDeferred.promise

  membershipsLoadedDeferred = $q.defer()
  global.cobudgetApp.membershipsLoaded = membershipsLoadedDeferred.promise

  work = (user) ->
    global.cobudgetApp.currentUserId = user.id
    userValidatedDeferred.resolve()
    Records.memberships.fetchMyMemberships().then (data) ->
      console.log('memberships loaded!')
      membershipsLoadedDeferred.resolve()

  $rootScope.$on 'auth:validation-success', (ev, user) ->
    console.log('validation success!')
    work(user)

  $rootScope.$on 'auth:login-success', (ev, user) ->
    console.log('login success!')
    work(user)

  $rootScope.$on 'auth:validation-error', () ->
    console.log('validation-error')
    $location.path('/')
    Toast.show('Please log in to continue')
    userValidatedDeferred.reject()
    membershipsLoadedDeferred.reject()
