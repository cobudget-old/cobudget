null

### @ngInject ###
global.cobudgetApp.directive 'landingPageToolbar', () ->
    restrict: 'E'
    template: require('./landing-page-toolbar.html')
    replace: true
    controller: (CurrentUser, $location, $scope) ->

      $scope.currentUser = CurrentUser()

      $scope.redirectToLoginPage = ->
        $location.path('/login')

      return
