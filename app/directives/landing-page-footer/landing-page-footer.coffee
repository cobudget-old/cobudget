null

### @ngInject ###
global.cobudgetApp.directive 'landingPageFooter', () ->
    restrict: 'E'
    template: require('./landing-page-footer.html')
    replace: true
    controller: ($location, $scope) ->

      $scope.redirectToLoginPage = ->
        $location.path('/login')

      $scope.redirectToResourcesPage = ->
        $location.path('/about')

      $scope.redirectToAboutPage = ->
        $location.path('/about')

      return
