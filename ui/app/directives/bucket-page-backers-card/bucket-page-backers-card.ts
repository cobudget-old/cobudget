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
global.cobudgetApp.directive('bucketPageBackersCard', () => ({
  restrict: 'E',
  template: require('./bucket-page-backers-card.html'),
  replace: true,

  scope: {
    contributions: '=',
    currentUser: '=',
    group: '=',
  },

  controller($scope) {
    const groupedContributions = _.groupBy($scope.contributions, 'userId');

    $scope.backers = _.map(groupedContributions, function(contributions) {
      const callback = (sum, contribution) => sum + contribution.amount;
      const totalContributionAmount = _.reduce(contributions, callback, 0);
      return {id: contributions[0].user().id, name: contributions[0].user().name, contributionAmount: totalContributionAmount};
  });

  },
}));
