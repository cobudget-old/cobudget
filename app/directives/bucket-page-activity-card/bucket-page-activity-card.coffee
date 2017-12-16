null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageActivityCard', () ->
    restrict: 'E'
    template: require('./bucket-page-activity-card.html')
    replace: true
    controller: (Records, $scope, Toast, $filter) ->

      $scope.newComment = Records.comments.build(bucketId: $scope.bucket.id)
      $scope.newComment.mentions = []

      $scope.createComment = ->
        $scope.commentCreated = true
        $scope.newComment.save().then ->
          Toast.show('You posted a comment')
          $scope.newComment = Records.comments.build(bucketId: $scope.bucket.id)
          $scope.newComment.mentions = []
          $scope.commentCreated = false

      $scope.getUserText = (item) ->
        $scope.newComment.mentions.push(item.userId)
        return '<a href="/">@' + item.name + '</a>'

      $scope.searchUsers = (term) ->
        $scope.users = $filter('filter')($scope.allUsers, term)

      Records.memberships.fetchByGroupId($scope.group.id).then ->
        $scope.allUsers = _.map $scope.group.settledMemberships(), (membership) ->
          {name: membership.member().name, email: membership.member().email, userId: membership.member().id}
        $scope.users = $scope.allUsers
