null

### @ngInject ###
global.cobudgetApp.directive 'groupPageToolbar', () ->
    restrict: 'E'
    template: require('./group-page-toolbar.html')
    replace: true
    controller: ($auth, $location, $mdBottomSheet, $rootScope, $scope, Toast, $window) ->

      $scope.openSidenav = ->
        $rootScope.$broadcast('open sidenav')

      $scope.openProfileSettings = ->
        $location.path('/profile_settings').search('previous_group_id', $scope.group.id)

      $scope.openFeedbackForm = ->
        $window.location.href = 'https://docs.google.com/forms/d/1-_zDQzdMmq_WndQn2bPUEW2DZQSvjl7nIJ6YkvUcp0I/viewform?usp=send_form';

      $scope.openAdminPanel = ->
        $location.path('/admin')

      $scope.createBucket = ->
        $location.path('/buckets/new').search('group_id', $scope.group.id)

      $scope.selectTab = (tabNum) ->
        $scope.tabSelected = parseInt tabNum

      $scope.openEmailSettings = ->
        $location.path('/email_settings').search('previous_group_id', $scope.group.id)

      $scope.openInvitePeople = ->
        console.log('invite-people-btn clicked!')

      $scope.openManageFunds = ->
        console.log('manage-funds-btn clicked!')

      $scope.signOut = ->
        $auth.signOut().then ->
          global.cobudgetApp.currentUserId = null
          $location.path('/')
          Toast.show('You\'ve been signed out')

      $scope.menuItems = [
        {label: 'Profile Settings', onClick: $scope.openProfileSettings, icon: 'person', isDisplayed: true},
        {label: 'Email Settings', onClick: $scope.openEmailSettings, icon: 'mail', isDisplayed: $scope.currentUser.isConfirmed()},
        {label: 'Give Feedback', onClick: $scope.openFeedbackForm, icon: 'live_help', isDisplayed: true},
        {label: 'Admin Panel', onClick: $scope.openAdminPanel, icon: 'local_pizza', isDisplayed: $scope.currentUser.isAGroupAdmin()},
        {label: 'Log Out', onClick: $scope.signOut, icon: 'exit_to_app', isDisplayed: true}
      ]

      $scope.accessibleMenuItems = ->
        _.filter $scope.menuItems, {isDisplayed: true}

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
