null

### @ngInject ###
global.cobudgetApp.run ($rootScope, Records, $q, $location) ->

  # userValidatedDeferred = $q.defer()

  # global.cobudgetApp.userValidated = userValidatedDeferred.promise

  # $rootScope.$on 'auth:validation-success', (user) ->
  #   console.log('validation-success')
  #   global.cobudgetApp.currentUserId = user.id
  #   userValidatedDeferred.resolve()

  # $rootScope.$on 'auth:validation-error', () ->
  #   console.log('validation-error')
  #   $location.path('/')
  #   Toast.show('Please log in to continue')
  #   userValidatedDeferred.reject()