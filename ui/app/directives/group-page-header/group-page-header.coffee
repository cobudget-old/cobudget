null

### @ngInject ###
global.cobudgetApp.directive 'groupPageHeader', () ->
    restrict: 'E'
    template: require('./group-page-header.html')
    replace: true
    controller: ($location, $mdBottomSheet, $scope, $window, $stateParams, $state) ->

      if $stateParams.tab == 'funders'
        $scope.tabSelected = 1
      else if $stateParams.tab == 'activity'
        $scope.tabSelected = 2
      else
        $scope.tabSelected = 0

      $scope.selectTab = (tabNum) ->
        if tabNum == 1
          tabName = 'funders'
        else if tabNum == 2
          tabName = 'activity'
        else
          tabName = 'buckets'
        $scope.tabSelected = tabNum
        $state.go('group', {groupId: $scope.group.id, tab: tabName}, {notify: false})

      $scope.createBucket = ->
        $location.path('/buckets/new').search('group_id', $scope.group.id)

      $scope.openInvitePeople = ->
        $location.path("/groups/#{$scope.group.id}/invite_members")
        $mdBottomSheet.cancel()

      $scope.openManageFunds = ->
        $location.path("/groups/#{$scope.group.id}/manage_funds")
        $mdBottomSheet.cancel()

      $scope.openGroupSettings = ->
        $location.path("/groups/#{$scope.group.id}/settings")
        $mdBottomSheet.cancel()

      $scope.openBottomSheet = ->
        $mdBottomSheet.show({
          preserveScope: true
          scope: $scope
          template: require('./bottom-sheet.tmpl.html')
          controller: ->
            $scope.adminActions = [
              {label: 'Invite Members', onClick: $scope.openInvitePeople},
              {label: 'Manage Funds', onClick: $scope.openManageFunds},
              {label: 'Group Settings', onClick: $scope.openGroupSettings},
              {label: 'Cancel', onClick: $mdBottomSheet.cancel, icon: 'cancel'}
            ]
        })

      return
