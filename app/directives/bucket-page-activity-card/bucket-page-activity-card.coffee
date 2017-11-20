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

      Records.memberships.fetchByGroupId($scope.group.id).then ->
        $scope.users = _.map $scope.group.settledMemberships(), (membership) ->
          {label: membership.member().name}
