null

### @ngInject ###
global.cobudgetApp.directive 'landingPageToolbar', () ->
    restrict: 'E'
    template: require('./landing-page-toolbar.html')
    replace: true
    controller: ($location, $scope) ->

      $scope.redirectToLoginPage = ->
        $location.path('/login')

      $scope.redirectToHomePage = ->
        $location.path('/')

      $scope.redirectToCaseStudiesPage = ->
        $location.path('/case-studies')

      $scope.redirectToAboutPage = ->
        $location.path('/about')

      return
