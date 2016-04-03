null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageToolbar', () ->
    restrict: 'E'
    template: require('./bucket-page-toolbar.html')
    replace: true
    controller: ($location, $scope, Toast) ->

      $scope.edit = ->
        $location.path("/buckets/#{$scope.bucket.id}/edit")

      $scope.userCanEditBucket = ->
        $scope.bucket && $scope.userCanStartFunding()

      $scope.archive = ->
        console.log('meow')

      return
