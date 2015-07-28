global.cobudgetApp.directive 'groupsPage', ->
  restrict: 'E'
  template: require('app/components/groups-page/groups-page.html')
  replace: true # what is this?
  controller: ($scope, Records) ->
    $scope.hello = "hi"
