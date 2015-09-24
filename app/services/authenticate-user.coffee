null

### @ngInject ###
global.cobudgetApp.factory 'AuthenticateUser', (Records, ipCookie, Toast, $location, $stateParams, $q, $auth, CurrentUser) ->
  () ->
    deferred = $q.defer()

    if ipCookie('currentUserId') # if currentUserId still in session
      Records.memberships.fetchMyMemberships()
        .then (data) -> # user logged in
          if groupId = parseInt($stateParams.groupId)
            if !(_.find data.groups, (group) -> group.id == groupId) 
              Toast.show('The group you were trying to access is private, please sign in to continue')
              ipCookie.remove('initialRequestPath')
              $location.path('/')
              deferred.reject()
          if bucketId = parseInt($stateParams.bucketId)
            bucket = Records.buckets.findOrFetchById(bucketId).then (bucket) ->
              userIsMemberOfBucketGroup = _.find data.groups, (group) ->
                group.id == bucket.groupId
              if !userIsMemberOfBucketGroup
                Toast.show('The bucket you were trying to access is private, please sign in to continue')
                ipCookie.remove('initialRequestPath')
                $location.path('/')
                deferred.reject()
          deferred.resolve(CurrentUser())
        .catch (data) -> # user not logged in
          Toast.show('Please log in to continue')
          ipCookie.remove('currentUserId')
          ipCookie.remove('currentGroupId')
          $location.path('/')
          deferred.reject()
    else # if currentUserId not in session
      ipCookie('initialRequestPath', $location.path())
      Toast.show('You must sign in to continue')
      $location.path('/')
      deferred.reject()

    return deferred.promise