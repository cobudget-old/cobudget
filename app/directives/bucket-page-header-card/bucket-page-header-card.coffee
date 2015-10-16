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
        linkedText = $filter('linky')($scope.bucket.description, '_blank')
        if $scope.showMore then linkedText else $filter('characters')(linkedText, 200, false)

      return