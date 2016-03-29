module.exports =
  url: '/email_settings?previous_group_id'
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  template: require('./email-settings-page.html')
  reloadOnSearch: false
  controller: (CurrentUser, Error, $location, Records, $scope, $stateParams, Toast, UserCan) ->

    if UserCan.changeEmailSettings()
      $scope.authorized = true
      Error.clear()
    else
      $scope.authorized = false
      Error.set("you can't view this page")

    $scope.currentUser = CurrentUser()
    $scope.subscriptionTracker = $scope.currentUser.subscriptionTracker()
    previousGroupId = $stateParams.previous_group_id || CurrentUser().primaryGroup().id

    $scope.settings = [
      { property: 'commentsOnBucketsUserAuthored', header: 'comment on your bucket' },
      { property: 'commentsOnBucketsUserParticipatedIn', header: 'comment on a bucket you participated in' },
      { property: 'contributionsToLiveBucketsUserAuthored', header: 'funding for your bucket' },
      { property: 'contributionsToLiveBucketsUserParticipatedIn', header: 'funding in a bucket you participated in' },
      { property: 'fundedBucketsUserAuthored', header: 'your bucket funded fully' },
      { property: 'newDraftBuckets', header: 'new bucket idea created' },
      { property: 'newLiveBuckets', header: 'new bucket put up for funding' },
      { property: 'newFundedBuckets', header: 'new bucket funded' }
    ]

    $scope.notificationFrequencyOptions = ['never', 'hourly', 'daily', 'weekly']

    $scope.cancel = ->
      $location.search('previous_group_id', null)
      $location.path("/groups/#{previousGroupId}")

    $scope.done = ->
      params = _.pick $scope.currentUser, [
        'subscribedToDailyDigest',
        'subscribedToPersonalActivity',
        'subscribedToParticipantActivity'
      ]
      Records.users.updateProfile(params).then ->
        Toast.show('Email settings updated!')
        $scope.cancel()

    return
