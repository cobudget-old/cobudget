null

### @ngInject ###
global.cobudgetApp.run ($auth, CurrentUser, Dialog, LoadBar, $location, $q, Records, $rootScope, Toast, $window) ->

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

      if CurrentUser().isActive() # redirect to group page with toast, set timezone, and confirm user if necessary
        groupId = data.groups[0].id
        $location.path("/groups/#{groupId}")
        Toast.show('Welcome to Cobudget!')
        if CurrentUser().utcOffset != moment().utcOffset()
          Records.users.updateProfile(utc_offset: moment().utcOffset())
        if !CurrentUser().isConfirmed
          Records.users.updateProfile(confirmationToken: null)
      else # if user is archived, log user out, display error dialog, and redirect home
        $auth.signOut().then ->
          global.cobudgetApp.currentUserId = null
          $location.path('/')
          Dialog.alert(title: 'error!', content: 'invalid credentials!')
          LoadBar.stop()

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
