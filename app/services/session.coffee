null

### @ngInject ###
global.cobudgetApp.factory 'Session', ($auth, CurrentUser, $q) ->
  new class Session

    clear: ->
      deferred = $q.defer()
      if CurrentUser()
        $auth.signOut().then ->
          global.cobudgetApp.currentUserId = null
          deferred.resolve()
      else
        deferred.resolve()
      deferred.promise
