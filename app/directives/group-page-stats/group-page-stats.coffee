null

### @ngInject ###
global.cobudgetApp.directive 'groupPageStats', () ->
    restrict: 'E'
    template: require('./group-page-stats.html')
    replace: true
    controller: ($scope, $location) ->

     $scope.showBucket = (bucketId) ->
       $location.path("/buckets/#{bucketId}")


      return
