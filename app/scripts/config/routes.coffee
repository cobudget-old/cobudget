`// @ngInject`
window.Cobudget.Config.Router = ($routeProvider) ->
  $routeProvider
    .when '/budgets/:budgetId',
      templateUrl: '/views/budget-overview.html'
      controller: window.Cobudget.Controllers.BudgetOverview
    .when '/budgets/:budgetId/contributors',
      templateUrl: '/views/budget-contributors.html'
      controller: window.Cobudget.Controllers.BudgetContributors
    .when '/budgets/:budgetId/my-allocation',
      templateUrl: '/views/budget-allocations.html'
      controller: window.Cobudget.Controllers.BudgetAllocations
    .when '/buckets/:bucketId',
      templateUrl: '/views/bucket-show.html'
      controller: window.Cobudget.Controllers.BucketShow
    .otherwise(redirectTo: '/budgets/1')
