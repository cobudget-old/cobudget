null

### @ngInject ###
global.cobudgetApp.run ($auth, CurrentUser, Dialog, LoadBar, $location, $q, Records, $rootScope, Toast, $window) ->

  membershipsLoadedDeferred = $q.defer()
  announcementsLoadedDeferred = $q.defer()
  global.cobudgetApp.membershipsLoaded = membershipsLoadedDeferred.promise
  global.cobudgetApp.announcementsLoaded = announcementsLoadedDeferred.promise


  $rootScope.$on 'auth:validation-success', (ev, user) ->
    global.cobudgetApp.currentUserId = user.id
    path_components = $location.path().split('/')
    if path_components[1] == "groups"
      groupId = path_components[2]
    else if path_components[1] == "buckets"
      bucketId = parseInt path_components[2]
      console.log("bucketId")
      console.log(bucketId)
      Records.buckets.findOrFetchById(bucketId).then(bucket) ->
        console.log("bucket")
        console.log(bucket)
        groupId = bucket.group().id
    else
      groupId = null
    console.log("groupId")
    console.log(groupId)
    Records.memberships.fetchMyMemberships(groupId).then (data) ->
      membershipsLoadedDeferred.resolve(data)
    Records.announcements.fetch({}).then (data) ->
      announcementsLoadedDeferred.resolve(data)

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
      announcementsLoadedDeferred.reject()
      Toast.show('Please log in to continue')
      $location.path('/')
    else
      $window.location.reload()
