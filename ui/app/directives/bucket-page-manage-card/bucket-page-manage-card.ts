/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.directive('bucketPageManageCard', () => ({
  restrict: 'E',
  template: require('./bucket-page-manage-card.html'),
  replace: true,

  controller(Dialog, $scope, $location) {

    $scope.edit = () => $location.path(`/buckets/${$scope.bucket.id}/edit`);

    $scope.cancel = function() {
      const cancelBucketDialog = require('./../../components/cancel-bucket-dialog/cancel-bucket-dialog.coffee')({
        scope: $scope
      });
      return Dialog.open(cancelBucketDialog);
    };

    $scope.refund = function() {
      const refundBucketDialog = require('./../../components/refund-bucket-dialog/refund-bucket-dialog.coffee')({
        scope: $scope
      });
      return Dialog.open(refundBucketDialog);
    };

  }
}));
