null

### @ngInject ###
global.cobudgetApp.directive 'errorPage', () ->
    restrict: 'E', 
    scope: {},
    template: require('./error-page.html'),
    replace: true
    controller: ($scope) ->

      $scope.error = null

      $scope.$on 'set error', (e, msg) ->
        $scope.error = msg
        
      $scope.$on 'clear error', (e) ->
        $scope.error = null