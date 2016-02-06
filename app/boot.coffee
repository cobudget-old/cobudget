null

### @ngInject ###
global.cobudgetApp.run ($auth, CurrentUser, Dialog, LoadBar, $location, $q, Records, $rootScope, Toast, $window) ->

  membershipsLoadedDeferred = $q.defer()
  global.cobudgetApp.membershipsLoaded = membershipsLoadedDeferred.promise

  $rootScope.$on 'auth:validation-success', (ev, user) ->
    global.cobudgetApp.currentUserId = user.id
    Records.memberships.fetchMyMemberships().then (data) ->
      membershipsLoadedDeferred.resolve(data)

  $rootScope.$on 'auth:login-success', (ev, user) ->
    global.cobudgetApp.currentUserId = user.id
    Records.memberships.fetchMyMemberships().then (data) ->
      membershipsLoadedDeferred.resolve()
      Records.users.fetchMe().then ->
        if CurrentUser().hasEverJoinedAGroup()
          if CurrentUser().hasMemberships()
            groupId = data.groups[0].id
            $location.path("/groups/#{groupId}")
            Toast.show('Welcome to Cobudget!')
            Records.users.updateProfile(utc_offset: moment().utcOffset())
          else
            $auth.signOut().then ->
              global.cobudgetApp.currentUserId = null
              $location.path('/')
              Dialog.alert(title: 'error!', content: 'invalid credentials!')
              LoadBar.stop()
        else
          LoadBar.stop()

  $rootScope.$on 'auth:login-error', (ev, reason) ->
    Dialog.alert(title: 'error!', content: reason.errors[0])

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
