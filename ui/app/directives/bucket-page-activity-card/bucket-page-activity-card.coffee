null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageActivityCard', () ->
    restrict: 'E'
    template: require('./bucket-page-activity-card.html')
    replace: true
    controller: (Records, $scope, Toast) ->

      $scope.newComment = Records.comments.build(bucketId: $scope.bucket.id)

      $scope.createComment = ->
        $scope.commentCreated = true
        $scope.newComment.save().then ->
          Toast.show('You posted a comment')
          $scope.newComment = Records.comments.build(bucketId: $scope.bucket.id)
          $scope.commentCreated = false
