/* eslint-disable
    no-undef,
    no-unused-vars,
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
global.cobudgetApp.directive('groupPageStats', () => ({
  restrict: 'E',
  template: require('./group-page-stats.html'),
  replace: true,

  controller(config, $scope, $http, $stateParams, $filter, Records) {

    const groupId = parseInt($stateParams.groupId);

    // transaciton table
    $scope.transactionQuery = '';
    $scope.transactionColumns = ['createdAtFormatted', 'account_from', 'account_to', 'amount'];
    $scope.transactionHeaders = ['Created At', 'Account From', 'Account To', 'Amount'];

    $scope.$watch('transactionQuery', () => $scope.filteredTransactions = $filter('filter')($scope.allTransactions, $scope.transactionQuery));

    $http.get(config.apiPrefix + `/groups/${groupId}/analytics`)
      .then(function(res) {
        $scope.transactionsLoaded = true;
        $scope.allTransactions = res.data.group_data;
        $scope.filteredTransactions = $scope.allTransactions;
        $scope.initialOrderTransactions = '-created_at';
        $scope.transactionLimit = 10;
        $scope.startingPageTransactions = 1;
        return _.each($scope.allTransactions, transaction => transaction.createdAtFormatted = moment(transaction.created_at).format('MMMM D YYYY HH:mm'));
    });

    // bucket table
    $scope.bucketQuery = '';
    $scope.bucketHeaders = ['Bucket Name', 'Link', 'Bucket Owner', 'Bucket Owner Email', 'Total Contributions', 'Funded At', 'Completed At'];
    $scope.bucketColumns = ['name', 'url', 'authorName', 'authorEmail', 'totalContributions', 'fundedAtFormatted', 'paidAtFormatted'];

    $scope.$watch('bucketQuery', () => $scope.filteredBuckets = $filter('filter')($scope.fundedBuckets, {name: $scope.bucketQuery}));

    Records.buckets.fetchByGroupId(groupId).then(function(data) {
      $scope.bucketsLoaded = true;
      $scope.fundedBuckets = $scope.group.fundedBuckets();
      $scope.filteredBuckets = $scope.fundedBuckets;
      $scope.fundedCompletedBuckets = $scope.group.fundedCompletedBuckets();
      _.each($scope.fundedCompletedBuckets, function(bucket) {
        bucket.url = location.origin + '/#/buckets/' + bucket.id;
        bucket.authorEmail = bucket.author().email;
        bucket.fundedAtFormatted = moment(bucket.fundedAt).format('MMMM D YYYY HH:mm');
        return bucket.paidAtFormatted = bucket.paidAt ? moment(bucket.paidAt).format('MMMM D YYYY HH:mm') : 'Not Complete';
      });
      $scope.bucketLimit = 10;
      $scope.startingPageBuckets = 1;
      return $scope.initialOrderBuckets = '-fundedAt';
    });

  },
}));
