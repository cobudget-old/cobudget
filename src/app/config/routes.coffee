`// @ngInject`
window.Cobudget.Config.Router = ($routeProvider) ->
  $routeProvider
    .when '/budgets/:budgetId',
      templateUrl: '/app/budget-overview/budget-overview.html'
      controller: window.Cobudget.Controllers.BudgetOverview
    .when '/budgets/:budgetId/contributors',
      templateUrl: '/views/budget-contributors.html'
      controller: window.Cobudget.Controllers.BudgetContributors
    .when '/budgets/:budgetId/my-allocation',
      templateUrl: '/views/budget-allocations.html'
      controller: window.Cobudget.Controllers.BudgetAllocations
    .when '/buckets/:bucketId',
      templateUrl: '/app/buckets-page/bucket-details/bucket-details.html'
      controller: window.Cobudget.Controllers.BucketShow
    .otherwise(redirectTo: '/budgets/1')
