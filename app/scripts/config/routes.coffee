`// @ngInject`
window.Cobudget.Config.Router = ($routeProvider) ->
  $routeProvider
    .when '/budgets/:budget_id',
      templateUrl: '/views/budget-overview.html'
      controller: window.Cobudget.Controllers.BudgetOverview
    .when '/budgets/:budget_id/contributors',
      templateUrl: '/views/budget-contributors.html'
      controller: window.Cobudget.Controllers.BudgetContributors
    .when '/budgets/:budget_id/my-allocation',
      templateUrl: '/views/budget-allocations.html'
      controller: window.Cobudget.Controllers.BudgetAllocations
    .when '/buckets/:budget_id',
      templateUrl: '/views/bucket-show.html'
      controller: window.Cobudget.Controllers.BucketShow
    .otherwise(redirectTo: '/budgets/1')
