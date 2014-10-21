`// @ngInject`
window.Cobudget.Config.Router = ($routeProvider) ->
  $routeProvider
    .when '/groups/:groupId',
      templateUrl: '/app/budget-overview/budget-overview.html'
      controller: 'BudgetOverviewCtrl'
    .when '/groups/:groupId/contributors',
      templateUrl: '/app/budget-contributors/budget-contributors.html'
      controller: 'BudgetContributorsCtrl'
    .when '/groups/:groupId/my-contributions',
      templateUrl: '/app/my-contributions/my-contributions.html'
      controller: 'MyContributionsCtrl'
    .when '/groups/:groupId/buckets',
      templateUrl: '/app/buckets-page/buckets-page.html'
      controller: ''
    .when '/buckets/:bucketId',
      templateUrl: '/app/buckets-page/buckets-page.html'
      controller: 'BucketDetailsCtrl'
    .otherwise(redirectTo: '/groups/1')
