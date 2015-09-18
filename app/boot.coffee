null

### @ngInject ###
global.cobudgetApp.run ($rootScope, Records, $q, $location) ->

  # membershipsLoadedDeferred = $q.defer() # creates a new deferred object with a promise attr
  # global.cobudgetApp.membershipsLoaded = membershipsLoadedDeferred.promise # copy reference to the promise, so its globally accessible to the controller resolve

  # authSuccess = (event, user) ->
  #   global.cobudgetApp.currentUserId = user.id
  #   Records.memberships.fetchMyMemberships().then (data) ->
  #     if !global.cobudgetApp.currentGroupId
  #       global.cobudgetApp.currentGroupId = data.groups[0].id
  #     membershipsLoadedDeferred.resolve(true) # when me have all of the memberships, resolve the promise -- the controller loads

  # $rootScope.$on 'auth:validation-success', (event, user) ->
  #   authSuccess(event, user)

  # $rootScope.$on 'auth:login-success', (event, user) ->
  #   authSuccess(event, user).then ->
  #     $location.path("/groups/#{global.cobudgetApp.currentGroupId}")