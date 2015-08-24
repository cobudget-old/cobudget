null

### @ngInject ###
global.cobudgetApp.run ($rootScope, Records, $q, $location) ->

  membershipsLoadedDeferred = $q.defer() # creates a new deferred object with a promise attr
  global.cobudgetApp.membershipsLoaded = membershipsLoadedDeferred.promise # copy reference to the promise, so its globally accessible to the controller resolve

  checkIfUserSignedIn = $q.defer()
  global.cobudgetApp.checkIfUserSignedIn = checkIfUserSignedIn.promise
  
  $rootScope.$on 'auth:validation-success', (event, user) ->
    console.log('user signed in')
    checkIfUserSignedIn.resolve(true)
    global.cobudgetApp.currentUserId = user.id
    Records.memberships.fetchMyMemberships().then ->
      membershipsLoadedDeferred.resolve(true) # when me have all of the memberships, resolve the promise -- the controller loads
  
  $rootScope.$on 'auth:validation-error', (event, user) ->
    console.log('user not signed in')
    checkIfUserSignedIn.resolve(true)
    $location.path('/')