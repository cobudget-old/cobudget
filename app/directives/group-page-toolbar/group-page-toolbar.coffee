null

### @ngInject ###
global.cobudgetApp.directive 'groupPageToolbar', () ->
    restrict: 'E'
    template: require('./group-page-toolbar.html')
    replace: true
    controller: ($auth, $location, $rootScope, $scope, Toast, $window) ->

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

      $scope.signOut = ->
        $auth.signOut().then ->
          global.cobudgetApp.currentUserId = null
          $location.path('/')
          Toast.show('You\'ve been signed out')

      $scope.menuItems = [
        {label: 'Profile Settings', onClick: $scope.openProfileSettings, icon: 'person', adminOnly: false},
        {label: 'Email Settings', onClick: $scope.openEmailSettings, icon: 'mail', adminOnly: false},
        {label: 'Give Feedback', onClick: $scope.openFeedbackForm, icon: 'live_help', adminOnly: false},
        {label: 'Admin Panel', onClick: $scope.openAdminPanel, icon: 'local_pizza', adminOnly: true},
        {label: 'Log Out', onClick: $scope.signOut, icon: 'exit_to_app', adminOnly: false}
      ]

      $scope.accessibleMenuItems = ->
        if $scope.currentUser.isAdminOf($scope.group)
          $scope.menuItems
        else
          _.filter $scope.menuItems, {adminOnly: false}

      return
