/* eslint-disable
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.directive('bucketPageActivityCard', () => ({
  restrict: 'E',
  template: require('./bucket-page-activity-card.html'),
  replace: true,

  controller(Records, $scope, Toast, $filter) {

    $scope.newComment = Records.comments.build({bucketId: $scope.bucket.id});

    $scope.createComment = function() {
      $scope.commentCreated = true;
      const newComment = angular.element('.bucket-page__comment-input').clone();

      newComment[0].innerHTML = newComment[0].innerHTML
        .replace(/(<a(.*?)<\/a>)/g, '')
        .replace(/(<!---)/g, '')
        .replace(/(-->)/g, '')
        .replace(/<div>/gi,'\n')
        .replace(/<\/div>/gi,'')
        .replace(/<br>/gi,'\n');
      $scope.newComment.body = newComment.text();

      return $scope.newComment.save().then(function() {
        Toast.show('You posted a comment');
        $scope.newComment = Records.comments.build({bucketId: $scope.bucket.id});
        return $scope.commentCreated = false;
      });
    };

    $scope.getUserText = item => '<a href="/users/'+item.userId+'" name='+item.userId+'>@' + item.name + '</a><!---[@' + item.name + '](uid:' + item.userId + ')-->';

    $scope.searchUsers = term => $scope.users = $filter('filter')($scope.allUsers, term);

    Records.memberships.fetchByGroupId($scope.group.id).then(function() {
      $scope.allUsers = _.map($scope.group.settledMemberships(), membership => ({
        name: membership.member().name,
        email: membership.member().email,
        userId: membership.member().id,
      }));
      return $scope.users = $scope.allUsers;
    });

    return $scope.openUserPage = () => $location.path('/user/:id').search('previous_bucket_id', $scope.bucket.id);
  },
}));
