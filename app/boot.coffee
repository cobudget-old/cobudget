null

### @ngInject ###
global.cobudgetApp.run ($auth, CurrentUser, Dialog, LoadBar, $location, $q, Records, $rootScope, Toast, $window) ->

  membershipsLoadedDeferred = $q.defer()
  announcementsLoadedDeferred = $q.defer()
  global.cobudgetApp.membershipsLoaded = membershipsLoadedDeferred.promise
  global.cobudgetApp.announcementsLoaded = announcementsLoadedDeferred.promise


  $rootScope.$on 'auth:validation-success', (ev, user) ->
    global.cobudgetApp.currentUserId = user.id
    pathComponents = $location.path().split('/')
    if pathComponents[1] == "groups"
      groupId = pathComponents[2]
      Records.memberships.fetchByGroupId(groupId).then (data) ->
        membershipsLoadedDeferred.resolve(data)
    else if pathComponents[1] == "buckets"
      bucketId = parseInt pathComponents[2]
      console.log("bucketId")
      console.log(bucketId)
      Records.buckets.findOrFetchById(bucketId).then (bucket) ->
        console.log("bucket")
        console.log(bucket)
        groupId = bucket.group().id
        Records.memberships.fetchByGroupId(groupId).then (data) ->
          membershipsLoadedDeferred.resolve(data)
    else
      groupId = null
      Records.memberships.fetchMyMemberships().then (data) ->
        membershipsLoadedDeferred.resolve(data)
    console.log("groupId")
    console.log(groupId)
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
