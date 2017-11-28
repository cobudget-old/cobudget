null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageActivityCard', () ->
    restrict: 'E'
    template: require('./bucket-page-activity-card.html')
    replace: true
    controller: (Records, $scope, Toast, $filter) ->

      $scope.newComment = Records.comments.build(bucketId: $scope.bucket.id)

      $scope.createComment = ->
        $scope.commentCreated = true
        $scope.newComment.save().then ->
          Toast.show('You posted a comment')
          $scope.newComment = Records.comments.build(bucketId: $scope.bucket.id)
          $scope.commentCreated = false

      $scope.getUserText = (item) ->
        '<a href="/">@' + item.label + '</a>'

      $scope.searchUsers = (term) ->
        $scope.users = $filter('filter')($scope.allUsers, term)
        # prodList = []
        # angular.forEach $scope.allUsers, (item) ->
        #   if item.label.toUpperCase().indexOf(term.toUpperCase()) >= 0
        #     prodList.push item
        #   return
        # $scope.users = prodList

      Records.memberships.fetchByGroupId($scope.group.id).then ->
        $scope.allUsers = _.map $scope.group.settledMemberships(), (membership) ->
          {label: membership.member().name}
        $scope.users = $scope.allUsers
