`// @ngInject`
window.Cobudget.Config.Router = ($routeProvider) ->
  $routeProvider
    .when '/budgets/:budgetId',
      templateUrl: '/app/budget-overview/budget-overview.html'
      controller: 'BudgetOverviewCtrl'
    .when '/budgets/:budgetId/contributors',
      templateUrl: '/app/budget-contributors/budget-contributors.html'
      controller: 'BudgetContributorsCtrl'
    .when '/budgets/:budgetId/my-contributions',
      templateUrl: '/app/my-contributions/my-contributions.html'
      controller: 'MyContributionsCtrl'
    .when '/budgets/:budgetId/buckets',
      templateUrl: '/app/buckets-page/buckets-page.html'
      controller: ''
    .when '/buckets/:bucketId',
      templateUrl: '/app/buckets-page/buckets-page.html'
      controller: 'BucketDetailsCtrl'
    .otherwise(redirectTo: '/budgets/1')
