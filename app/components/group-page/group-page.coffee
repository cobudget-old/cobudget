module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId'
  template: require('./group-page.html')
  params:
    openMembersTab: null
    firstTimeSeeingGroup: null
  controller: (CurrentUser, Error, LoadBar, $location, Records, $scope, $stateParams, UserCan) ->
    LoadBar.start()

    if $stateParams.openMembersTab
      $scope.tabSelected = 1

    $scope.firstTimeSeeingGroup = $stateParams.firstTimeSeeingGroup
    $scope.welcomeCardClosed = false

    groupId = parseInt($stateParams.groupId)
    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        if UserCan.viewGroup(group)
          $scope.authorized = true
          Error.clear()
          $scope.group = group
          $scope.currentUser = CurrentUser()
          $scope.membership = group.membershipFor(CurrentUser())
          Records.memberships.fetchByGroupId(groupId)
          Records.buckets.fetchByGroupId(groupId).then ->
            LoadBar.stop()
          Records.contributions.fetchByGroupId(groupId)
        else
          $scope.authorized = false
          LoadBar.stop()
          Error.set('cannot view group')
      .catch ->
        LoadBar.stop()
        Error.set('group not found')

    $scope.adminWelcomeCardDisplayed = ->
      ($scope.firstTimeSeeingGroup && $scope.membership.isAdmin && !$scope.membership.closedAdminHelpCardAt && !$scope.welcomeCardClosed)

    $scope.adminLaunchCardDisplayed = ->
      !$scope.adminWelcomeCardDisplayed() && !$scope.group.isLaunched && !$scope.membership.closedAdminHelpCardAt && $scope.membership.isAdmin

    $scope.memberWelcomeCardDisplayed = ->
      !$scope.membership.isAdmin && !$scope.membership.closedMemberHelpCardAt

    $scope.closeAdminWelcomeCard = ->
      $scope.welcomeCardClosed = true

    $scope.closeLaunchCard = ->
      $scope.membership.remote.update $scope.membership.id,
        membership:
          closed_admin_help_card_at: moment()

    $scope.closeMemberWelcomeCard = ->
      $scope.membership.remote.update $scope.membership.id,
        membership:
          closed_member_help_card_at: moment()

    return
