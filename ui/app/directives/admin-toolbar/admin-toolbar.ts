null

### @ngInject ###
global.cobudgetApp.directive 'adminToolbar', () ->
    restrict: 'E'
    template: require('./admin-toolbar.html')
    replace: true
    controller: ($location, $scope, $stateParams) ->

      groupId = parseInt($stateParams.groupId)

      $scope.cancel = ->
        $location.path("/groups/#{groupId}")
