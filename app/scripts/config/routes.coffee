window.Cobudget.Router = ($routeProvider) ->
  $routeProvider
    .when '/budget/:id',
      templateUrl: '/views/budget-overview.html'
      controller: window.Cobudget.BudgetOverviewController
    .when '/budget/:id/contributors',
      templateUrl: '/views/budget-contributors.html'
      controller: window.Cobudget.BudgetContributorsController
    .when '/budget/:id/my-allocation',
      templateUrl: '/views/budget-allocations.html'
      controller: window.Cobudget.BudgetAllocationController
    .otherwise(redirectTo: '/budget/1')
