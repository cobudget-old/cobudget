// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default params => ({
  template: require('./remove-membership-dialog.html'),
  scope: params.scope,

  controller(Dialog, $mdDialog, $scope, $window, $filter) {
    const {
      membership,
    } = params;
    $scope.member = membership.member();
    $scope.userHasFunds = membership.rawBalance !== 0;
    if (!$scope.userHasFunds) {
      $scope.warnings = [
        'All of their ideas will be cancelled',
        'All of their funding and funded buckets will be cancelled and money will be refunded',
      ];
    } else {
      $scope.warnings = [
        $scope.member.name + ' has ' + $filter('currency')(membership.rawBalance, $scope.group.currencySymbol, 2)  + ' in ' + $scope.group.name,
        'You need to zero out ' + $scope.member.name + "'s funds before removing from group",
      ];
    }
    $scope.cancel = () => $mdDialog.cancel();
    return $scope.proceed = function() {
      $mdDialog.hide();
      return membership.cancel()
        .then(() => Dialog.alert({
        title: 'Success!',
        content: `${$scope.member.name} was removed from ${$scope.group.name}`,
      }).then(() => $window.location.reload())).catch(err => Dialog.alert({
        title: 'Error!',
        content: err.data.errors,
        }));
    };
  },
});
