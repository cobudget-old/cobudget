window.Cobudget.Config.Router = ($routeProvider) ->
  $routeProvider
    .when '/budget/:id',
      templateUrl: '/views/budget-overview.html'
      controller: window.Cobudget.Controllers.BudgetOverview
    .when '/budget/:id/contributors',
      templateUrl: '/views/budget-contributors.html'
      controller: window.Cobudget.Controllers.BudgetContributors
    .when '/budget/:id/my-allocation',
      templateUrl: '/views/budget-allocations.html'
      controller: window.Cobudget.Controllers.BudgetAllocation
    .otherwise(redirectTo: '/budget/1')
