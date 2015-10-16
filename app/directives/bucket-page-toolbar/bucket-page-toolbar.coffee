null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageToolbar', () ->
    restrict: 'E'
    template: require('./bucket-page-toolbar.html')
    replace: true
    controller: ($location, $scope, Toast) ->
      
      $scope.editBucket = ->
        $location.path("/buckets/#{$scope.bucket.id}/edit")

      $scope.userCanEditBucket = ->
        $scope.bucket && $scope.userCanStartFunding()

      return