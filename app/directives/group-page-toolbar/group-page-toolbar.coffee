null

### @ngInject ###
global.cobudgetApp.directive 'groupPageToolbar', () ->
    restrict: 'E'
    template: require('./group-page-toolbar.html')
    replace: true
    controller: ($rootScope, $scope) ->

      $scope.openSidenav = ->
        $rootScope.$broadcast('open sidenav')

      return
