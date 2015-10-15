null

### @ngInject ###
global.cobudgetApp.run ($rootScope, Records, $q, $location, $auth, Toast, CurrentUser) ->

  console.log('boot.coffee has loaded')

  userValidatedDeferred = $q.defer()
  global.cobudgetApp.userValidated = userValidatedDeferred.promise

  membershipsLoadedDeferred = $q.defer()
  global.cobudgetApp.membershipsLoaded = membershipsLoadedDeferred.promise

  onValidationError = () ->
    userValidatedDeferred.reject()
    membershipsLoadedDeferred.reject()
    global.cobudgetApp.currentUserId = null
    $location.path('/')
    Toast.show('Please log in to continue')

  $auth.validateUser()
    .then (user) ->
      console.log("user: ", user)
      onAuthSuccess(user)
    .catch ->
      console.log('catch onValidationError()')
      onValidationError()

  onAuthSuccess = (user) ->
    global.cobudgetApp.currentUserId = user.id
    userValidatedDeferred.resolve()
    Records.memberships.fetchMyMemberships().then (data) ->
      console.log('memberships loaded!')
      membershipsLoadedDeferred.resolve()

  $rootScope.$on 'auth:validation-success', (ev, user) ->
    console.log('validation success!')
    onAuthSuccess(user)

  $rootScope.$on 'auth:login-success', (ev, user) ->
    console.log('login success!')
    onAuthSuccess(user).then ->
      $location.path("/groups/#{CurrentUser().groups()[0].id}")

  $rootScope.$on 'auth:invalid', ->
    console.log("$rootScope.$on 'auth:invalid' onValidationError()")
    onValidationError()
