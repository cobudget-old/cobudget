null

### @ngInject ###
global.cobudgetApp.factory 'AuthenticateUser', (Toast, $location, $q, $auth) ->
  () ->
    deferred = $q.defer()
    $auth.validateUser()
      .then (user) ->
        deferred.resolve(user)
      .catch ->
        $location.path('/')
        Toast.show('Please log in to continue')
        deferred.reject()
    return deferred.promise