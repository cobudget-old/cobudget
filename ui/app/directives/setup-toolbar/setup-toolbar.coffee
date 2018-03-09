null

### @ngInject ###
global.cobudgetApp.directive 'setupToolbar', () ->
    restrict: 'E'
    template: require('./setup-toolbar.html')
    replace: true
    controller: (CurrentUser, $location, $scope) ->

      $scope.currentUser = CurrentUser()

      $scope.redirectToLoginPage = ->
        $location.path('/login')

      return
