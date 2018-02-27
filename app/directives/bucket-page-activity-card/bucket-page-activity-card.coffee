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
        newComment = jQuery('.bucket-page__comment-input').clone()

        newComment[0].innerHTML = newComment[0].innerHTML
          .replace(/(<a(.*?)<\/a>)/g, '')
          .replace(/(<!---)/g, '')
          .replace(/(-->)/g, '')
          .replace(/<div>/gi,'\n')
          .replace(/<\/div>/gi,'')
          .replace(/<br>/gi,'\n')
        $scope.newComment.body = newComment.text()

        $scope.newComment.save().then ->
          Toast.show('You posted a comment')
          $scope.newComment = Records.comments.build(bucketId: $scope.bucket.id)
          $scope.commentCreated = false

      $scope.getUserText = (item) ->
        return '<a href="/users/'+item.userId+'" name='+item.userId+'>@' + item.name + '</a><!---[@' + item.name + '](uid:' + item.userId + ')-->'

      $scope.searchUsers = (term) ->
        $scope.users = $filter('filter')($scope.allUsers, term)

      Records.memberships.fetchByGroupId($scope.group.id).then ->
        $scope.allUsers = _.map $scope.group.settledMemberships(), (membership) ->
          {name: membership.member().name, email: membership.member().email, userId: membership.member().id}
        $scope.users = $scope.allUsers

      $scope.openUserPage = ->
        $location.path('/user/:id').search('previous_bucket_id', $scope.bucket.id)
