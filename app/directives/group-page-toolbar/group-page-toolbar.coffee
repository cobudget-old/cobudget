null

### @ngInject ###
global.cobudgetApp.directive 'groupPageToolbar', () ->
    restrict: 'E'
    template: require('./group-page-toolbar.html')
    replace: true
    controller: ($location, $mdBottomSheet, $rootScope, $scope) ->

      $scope.openSidenav = ->
        $rootScope.$broadcast('open sidenav')

      $scope.createBucket = ->
        $location.path('/buckets/new').search('group_id', $scope.group.id)

      $scope.selectTab = (tabNum) ->
        $scope.tabSelected = parseInt tabNum

      $scope.openInvitePeople = ->
        console.log('invite-people-btn clicked!')
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
              {label: 'Invite People', onClick: $scope.openInvitePeople, icon: 'person_add'},
              {label: 'Manage Funds', onClick: $scope.openManageFunds, icon: 'attach_money'},
              {label: 'Cancel', onClick: $mdBottomSheet.cancel, icon: 'cancel'}
            ]
        })

      return
