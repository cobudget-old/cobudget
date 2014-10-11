///

NOT CURRENTLY USED -
TO USE, LINK IN INDEX.html and angular module



angular.module('nav-bar', []).controller 'NavBarCtrl', ($timeout, $location, $scope, $rootScope, $routeParams, Budget, BudgetLoader) ->
	
  BudgetLoader.init($rootScope)

  # TODO much of this should be in a routing service
  # pulling in any route functionality from BudgetLoader

  $scope.$watch 'currentBudgetId', (currentBudgetId) ->
    if currentBudgetId > 0
      $location.path '/budgets/' + currentBudgetId
      BudgetLoader.setBudgetByRoute()

  $scope.budgets = $rootScope.budgets

  console.log('fuuuqqq')

  BudgetLoader.loadAll()
    #console.log(budgets)
///