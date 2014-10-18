`// @ngInject`
window.Cobudget.Config.Router = ($routeProvider) ->
  $routeProvider
    .when '/organizations/:budgetId',
      templateUrl: '/app/budget-overview/budget-overview.html'
      controller: 'BudgetOverviewCtrl'
    .when '/organizations/:budgetId/contributors',
      templateUrl: '/app/budget-contributors/budget-contributors.html'
      controller: 'BudgetContributorsCtrl'
    .when '/organizations/:budgetId/my-contributions',
      templateUrl: '/app/my-contributions/my-contributions.html'
      controller: 'MyContributionsCtrl'
    .when '/organizations/:budgetId/buckets',
      templateUrl: '/app/buckets-page/buckets-page.html'
      controller: ''
    .when '/buckets/:bucketId',
      templateUrl: '/app/buckets-page/buckets-page.html'
      controller: 'BucketDetailsCtrl'
    .otherwise(redirectTo: '/organizations/1')
