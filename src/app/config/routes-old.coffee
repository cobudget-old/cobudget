`// @ngInject`
window.Cobudget.Config.Router = ($routeProvider) ->
  $routeProvider
    .when '/groups/:budgetId',
      templateUrl: '/app/budget-overview/budget-overview.html'
      controller: 'BudgetOverviewCtrl'
    .when '/groups/:budgetId/contributors',
      templateUrl: '/app/budget-contributors/budget-contributors.html'
      controller: 'BudgetContributorsCtrl'
    .when '/groups/:budgetId/my-contributions',
      templateUrl: '/app/my-contributions/my-contributions.html'
      controller: 'MyContributionsCtrl'
    .when '/groups/:budgetId/buckets',
      templateUrl: '/app/buckets-page/buckets-page.html'
      controller: ''
    .when '/buckets/:bucketId',
      templateUrl: '/app/buckets-page/buckets-page.html'
      controller: 'BucketDetailsCtrl'
    .otherwise(redirectTo: '/groups/1')
