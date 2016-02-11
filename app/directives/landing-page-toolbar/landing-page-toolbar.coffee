null

### @ngInject ###
global.cobudgetApp.directive 'landingPageToolbar', () ->
    restrict: 'E'
    template: require('./landing-page-toolbar.html')
    replace: true
    controller: ($location, $scope) ->

      $scope.redirectToLoginPage = ->
        $location.path('/login')

      return
