window.Cobudget.Config.Router = ($routeProvider) ->
  $routeProvider
    .when '/budgets/:id',
      templateUrl: '/views/budget-overview.html'
      controller: window.Cobudget.Controllers.BudgetOverview
    .when '/budgets/:id/contributors',
      templateUrl: '/views/budget-contributors.html'
      controller: window.Cobudget.Controllers.BudgetContributors
    .when '/budgets/:id/my-allocation',
      templateUrl: '/views/budget-allocations.html'
      controller: window.Cobudget.Controllers.BudgetAllocation
    .when '/buckets/:id',
      templateUrl: '/views/bucket-show.html'
      controller: window.Cobudget.Controllers.BucketShow
    .otherwise(redirectTo: '/budgets/1')
