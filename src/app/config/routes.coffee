`// @ngInject`
window.Cobudget.Config.Router = ($routeProvider) ->
  $routeProvider
    .when '/budgets/:budgetId',
      templateUrl: '/app/budget-overview/budget-overview.html'
      controller: window.Cobudget.Controllers.BudgetOverview
    .when '/budgets/:budgetId/contributors',
      templateUrl: '/app/budget-contributors/budget-contributors.html'
      controller: window.Cobudget.Controllers.BudgetContributors
    .when '/budgets/:budgetId/my-contributions',
      templateUrl: '/app/my-contributions/my-contributions.html'
      controller: window.Cobudget.Controllers.BudgetAllocations
    .when '/budgets/:budgetId/buckets',
      templateUrl: '/app/buckets-page/buckets-page.html'
      controller: window.Cobudget.Controllers.BucketShow
    .when '/buckets/:bucketId',
      templateUrl: '/app/buckets-page/bucket-details/bucket-details.html'
      controller: window.Cobudget.Controllers.BucketShow
    .otherwise(redirectTo: '/budgets/1')
