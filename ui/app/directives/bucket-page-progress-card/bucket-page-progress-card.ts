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
cobudgetApp.directive('bucketPageProgressCard', () => ({
  restrict: 'E',
  template: require('./bucket-page-progress-card.html'),
  replace: true,

  controller(Dialog, $q, Records, $scope, $state, Toast) {

    const maxAllowableContribution = _.min([$scope.bucket.amountRemaining(), $scope.membership.balance]);

    $scope.percentContributed = () => (($scope.newContribution.amount || 0) / $scope.bucket.target) * 100;

    $scope.totalAmountFunded = () => parseFloat($scope.bucket.totalContributions) + ($scope.newContribution.amount || 0);

    $scope.normalizeContributionAmount = function() {
      if ($scope.newContribution.amount > maxAllowableContribution) {
        return $scope.newContribution.amount = +maxAllowableContribution.toFixed(2);
      }
    };

    $scope.submitContribution = function() {
      $scope.contributionSubmitted = true;
      return $scope.newContribution.save()
        .then(function() {
          const membershipPromise = Records.memberships.remote.fetchById($scope.membership.id);
          const bucketPromise = Records.buckets.remote.fetchById($scope.bucket.id);
          return $q.allSettled([membershipPromise, bucketPromise]).then(function() {
            $scope.newContribution = {};
            $state.reload();
            return Toast.show('You funded a bucket');
          });}).catch(err => console.log('err: ', err));
    };

  },
}));
