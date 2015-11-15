module.exports = 
  url: '/email_settings?previous_group_id'
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  template: require('./email-settings-page.html')
  controller: (CurrentUser, $location, $scope, $stateParams, Toast) ->

    $scope.currentUser = CurrentUser()
    previousGroupId = $stateParams.previous_group_id || CurrentUser().primaryGroup().id

    $scope.settings = [
      {
        isSelected: $scope.currentUser.subscribedToDailyDigest,
        header: "Daily summary email.", 
        description: "Each day, send an email with yesterday's unread activity in every group that you're part of."
      },
      {
        isSelected: $scope.currentUser.subscribedToPersonalActivity,
        header: "Activity in buckets I've created.", 
        description: "When you create a bucket, you are subscribed to all activity on that bucket."
      },
      {
        isSelected: $scope.currentUser.subscribedToParticipantActivity,
        header: "Activity in buckets I've participated in.", 
        description: "When you participate in a bucket, you will get all activity from that bucket mailed to you."
      }
    ]

    $scope.cancel = ->
      $location.search('previous_group_id', null)
      $location.path("/groups/#{previousGroupId}")

    $scope.done = ->


    return