null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageHeaderCard', () ->
    restrict: 'E'
    template: require('./bucket-page-header-card.html')
    replace: true
    controller: (marked, $scope) ->

      $scope.filteredBucketDescription = ->
        marked($scope.bucket.description)

      return
