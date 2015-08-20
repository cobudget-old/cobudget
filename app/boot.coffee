null

### @ngInject ###
global.cobudgetApp.run ($rootScope, Records, $q) ->
  deferred = $q.defer() # creates a new deferred object with a promise attr
  global.cobudgetApp.membershipsLoaded = deferred.promise # copy reference to the promise, so its globally accessible to the controller resolve
  $rootScope.$on 'auth:validation-success', (event, user) ->
    global.cobudgetApp.currentUserId = user.id
    Records.memberships.fetchMyMemberships().then ->
      deferred.resolve(true) # when me have all of the memberships, resolve the promise -- the controller loads