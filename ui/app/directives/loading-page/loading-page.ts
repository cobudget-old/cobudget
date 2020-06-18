null

### @ngInject ###
global.cobudgetApp.directive 'loadingPage', () ->
    restrict: 'E', 
    scope: {},
    template: require('./loading-page.html'),
    replace: true
    controller: ($scope) ->

      $scope.loading = false

      $scope.$on 'loading', ->
        $scope.loading = true

      $scope.$on 'loaded', ->
        $scope.loading = false