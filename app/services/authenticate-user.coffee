null

### @ngInject ###
global.cobudgetApp.factory 'AuthenticateUser', (Toast, $location, $q, $auth) ->
  () ->
    deferred = $q.defer()
    $auth.validateUser()
      .then (user) ->
        global.cobudgetApp.currentUserId = user.id
        deferred.resolve()
      .catch ->
        global.cobudgetApp.currentUserId = null
        $location.path('/')
        Toast.show('Please log in to continue')
        deferred.reject()
        
    return deferred.promise