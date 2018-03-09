null

### @ngInject ###
global.cobudgetApp.directive 'groupPageHelp', () ->
    restrict: 'E'
    template: require('./group-page-help.html')
    replace: true
    controller: (Dialog, $location, $scope, $stateParams) ->

      $scope.firstTimeSeeingGroup = $stateParams.firstTimeSeeingGroup
      $scope.welcomeCardClosed = false

      $scope.adminWelcomeCardDisplayed = ->
        ($scope.firstTimeSeeingGroup && $scope.membership.isAdmin && !$scope.membership.closedAdminHelpCardAt && !$scope.welcomeCardClosed)

      $scope.adminLaunchCardDisplayed = ->
        !$scope.adminWelcomeCardDisplayed() && !$scope.group.isLaunched && !$scope.membership.closedAdminHelpCardAt && $scope.membership.isAdmin

      $scope.memberWelcomeCardDisplayed = ->
        !$scope.membership.isAdmin && !$scope.membership.closedMemberHelpCardAt

      $scope.placeholderAdminWelcomeCardDisplayed = ->
        $scope.membership.isAdmin && $scope.group.buckets().length == 0 && !$scope.adminWelcomeCardDisplayed() && !$scope.adminLaunchCardDisplayed()

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

      # $scope.openSetupTourDialog = ->
        # Dialog.custom
        #   template: require('./setup-tour-dialog.tmpl.html')

      $scope.redirectToCreateBucketPage = ->
        $location.path('/buckets/new').search('group_id', $scope.group.id)

      return
