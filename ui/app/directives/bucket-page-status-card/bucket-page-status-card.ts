/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.directive('bucketPageStatusCard', () => ({
  restrict: 'E',
  template: require('./bucket-page-status-card.html'),
  replace: true,

  controller($scope, Toast, Dialog) {

    $scope.openForFunding = function() {
      if ($scope.bucket.target) {
        return $scope.bucket.openForFunding().then(function() {
          $scope.back();
          return Toast.showWithRedirect('You launched a bucket for funding', `/buckets/${$scope.bucket.id}`);
        });
      } else {
        return Dialog.alert({
          title: 'hi friend ~~',
          content: 'an estimated funding target must be specified before funding starts',
          ok: 'oh, ok!'
        });
      }
    };

    $scope.acceptFunding = function() {
      const finishBucketDialog = require('./../../components/finish-bucket-dialog/finish-bucket-dialog.coffee')({
        scope: $scope
      });
      return Dialog.open(finishBucketDialog);
    };

    return $scope.complete = function() {
      const completeBucketDialog = require('./../../components/complete-bucket-dialog/complete-bucket-dialog.coffee')({
        scope: $scope
      });
      return Dialog.open(completeBucketDialog);
    };
  }
}));
