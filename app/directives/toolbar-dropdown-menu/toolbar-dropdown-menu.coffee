null

### @ngInject ###
global.cobudgetApp.directive 'toolbarDropdownMenu', () ->
    restrict: 'E'
    template: require('./toolbar-dropdown-menu.html')
    replace: true
    controller: ($auth, $location, $scope, $state, Toast, $window) ->

      $scope.openProfileSettings = ->
        $location.path('/profile_settings').search('previous_group_id', $scope.group.id)

      $scope.openFeedbackForm = ->
        $window.location.href = 'https://docs.google.com/forms/d/1-_zDQzdMmq_WndQn2bPUEW2DZQSvjl7nIJ6YkvUcp0I/viewform?usp=send_form';

      $scope.openAdminPanel = ->
        $location.path('/admin')

      $scope.openEmailSettings = ->
        $location.path('/email_settings').search('previous_group_id', $scope.group.id)

      $scope.openGroupAnalytics = ->
        $state.go('group-analytics', {groupId: $scope.group.id})

      $scope.signOut = ->
        $auth.signOut().then ->
          global.cobudgetApp.currentUserId = null
          $location.path('/')
          Toast.show('You\'ve been signed out')

      $scope.menuItems = [
        {label: 'Profile Settings', onClick: $scope.openProfileSettings, icon: 'person', isDisplayed: true},
        {label: 'Email Settings', onClick: $scope.openEmailSettings, icon: 'mail', isDisplayed: $scope.currentUser.isConfirmed()},
        {label: 'Give Feedback', onClick: $scope.openFeedbackForm, icon: 'live_help', isDisplayed: true},
        {label: 'Group Analytics', onClick: $scope.openGroupAnalytics, icon: 'trending_up', isDisplayed: true},
        # {label: 'Admin Panel', onClick: $scope.openAdminPanel, icon: 'local_pizza', isDisplayed: $scope.currentUser.isAGroupAdmin()},
        {label: 'Log Out', onClick: $scope.signOut, icon: 'exit_to_app', isDisplayed: true}
      ]

      $scope.accessibleMenuItems = ->
        _.filter $scope.menuItems, {isDisplayed: true}

      return
