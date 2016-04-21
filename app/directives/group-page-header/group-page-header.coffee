null

### @ngInject ###
global.cobudgetApp.directive 'groupPageHeader', () ->
    restrict: 'E'
    template: require('./group-page-header.html')
    replace: true
    controller: ($location, $mdBottomSheet, $scope, $window) ->

      $scope.createBucket = ->
        $location.path('/buckets/new').search('group_id', $scope.group.id)

      $scope.selectTab = (tabNum) ->
        $scope.tabSelected = parseInt tabNum

      $scope.openInvitePeople = ->
        $location.path("/groups/#{$scope.group.id}/invite_members")
        $mdBottomSheet.cancel()

      $scope.openManageFunds = ->
        $location.path("/groups/#{$scope.group.id}/manage_funds")
        $mdBottomSheet.cancel()

      $scope.openBottomSheet = ->
        $mdBottomSheet.show({
          preserveScope: true
          scope: $scope
          template: require('./bottom-sheet.tmpl.html')
          controller: ->
            $scope.adminActions = [
              {label: 'Invite Members', onClick: $scope.openInvitePeople, icon: 'person_add'},
              {label: 'Manage Funds', onClick: $scope.openManageFunds, icon: 'attach_money'},
              {label: 'Cancel', onClick: $mdBottomSheet.cancel, icon: 'cancel'}
            ]
        })

      return
