window.Cobudget = {}
window.Cobudget.Router = ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: '/views/budget-overview.html'
      controller: window.Cobudget.BudgetController
