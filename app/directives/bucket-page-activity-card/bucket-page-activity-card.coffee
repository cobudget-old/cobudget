null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageActivityCard', () ->
    restrict: 'E'
    template: require('./bucket-page-activity-card.html')
    replace: true
    controller: ($scope, Records) ->

      $scope.newComment = Records.comments.build(bucketId: $scope.bucket.id)

      $scope.createComment = ->
        $scope.newComment.save()
        $scope.newComment = Records.comments.build(bucketId: $scope.bucket.id)
