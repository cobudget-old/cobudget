null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageHeaderCard', () ->
    restrict: 'E'
    template: require('./bucket-page-header-card.html')
    replace: true
    controller: ($filter, marked, $scope) ->

      # $scope.toggleMore = ->
      #   $scope.showMore = !$scope.showMore

      # $scope.moreButtonText = ->
      #   if $scope.showMore then "Show Less" else "Read More"
        
      $scope.filteredBucketDescription = ->
        # if $scope.showMore 
        marked($scope.bucket.description)
        # else
        #   $filter('characters')($scope.bucket.description, 200, false)

      # if container.height() == 200
      #   container.css({overflow: "hidden"})
      # find the text container and see what height it is.
      # if it's 200px
        # add overflow hidden
        # add text overlay
        # add read more button

      $scope.textTruncated = ->

      return