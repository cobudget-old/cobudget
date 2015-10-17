null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageHeaderCard', () ->
    restrict: 'E'
    template: require('./bucket-page-header-card.html')
    replace: true
    controller: ($scope, $filter) ->

      $scope.toggleMore = ->
        $scope.showMore = !$scope.showMore

      $scope.moreButtonText = ->
        if $scope.showMore then "Show Less" else "Read More"
        
      $scope.filteredBucketDescription = ->
        if $scope.showMore 
          $scope.bucket.description
        else
          $filter('characters')($scope.bucket.description, 200, false)

      return