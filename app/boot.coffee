null

### @ngInject ###
global.cobudgetApp.run ($auth, CurrentUser, $location, $q, Records, $rootScope, Toast, $window) ->

  membershipsLoadedDeferred = $q.defer()
  global.cobudgetApp.membershipsLoaded = membershipsLoadedDeferred.promise

  $rootScope.$on 'auth:validation-success', (ev, user) ->
    global.cobudgetApp.currentUserId = user.id
    Records.memberships.fetchMyMemberships().then ->
      membershipsLoadedDeferred.resolve()

  $rootScope.$on 'auth:login-success', (ev, user) ->
    global.cobudgetApp.currentUserId = user.id
    Records.memberships.fetchMyMemberships().then (data) ->
      if CurrentUser().utcOffset != moment().utcOffset()
        Records.users.updateProfile(utc_offset: moment().utcOffset()).then (data) ->
      membershipsLoadedDeferred.resolve()
      
      # during invite new group flow, user created and logged in without having a group yet
      # so we perform this quick check
      if data.groups
        groupId = data.groups[0].id
        $location.path("/groups/#{groupId}")
        Toast.show('Welcome to Cobudget!')

  $rootScope.$on '$stateChangeError', (e, toState, toParams, fromState, fromParams, error) ->
    console.log('$stateChangeError signal fired!')
    console.log('e: ', e)
    console.log('toState: ', toState)
    console.log('toParams: ', toParams)
    console.log('fromState: ', fromState)
    console.log('fromParams: ', fromParams)
    console.log('error: ', error)

    if error
      e.preventDefault()
      global.cobudgetApp.currentUserId = null
      membershipsLoadedDeferred.reject()
      Toast.show('Please log in to continue')
      $location.path('/')
    else
      $window.location.reload()
