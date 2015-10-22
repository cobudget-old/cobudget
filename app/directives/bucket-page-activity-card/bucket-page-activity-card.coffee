null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageActivityCard', () ->
    restrict: 'E'
    template: require('./bucket-page-activity-card.html')
    replace: true
    controller: (LoadBar, Records, $scope, Toast, $window) ->

      $scope.newComment = Records.comments.build(bucketId: $scope.bucket.id)

      $scope.createComment = ->
        LoadBar.start()
        $scope.newComment.save().then ->
          LoadBar.stop()
          Toast.show('You posted a comment')
          $scope.newComment = Records.comments.build(bucketId: $scope.bucket.id)
