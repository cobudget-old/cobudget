`// @ngInject`
window.Cobudget.Controllers.BudgetContributors = ($scope, $rootScope, $route, BudgetLoader, Budget) ->
  BudgetLoader.init($rootScope)
  BudgetLoader.loadFromURL()
  
  $rootScope.$watch 'currentBudget', (budget) ->
    return unless budget
    console.log(budget)


    Budget.getBudgetContributors(budget.id).then (contributors) ->
      _.each contributors, (contributor) ->
        #console.log(contributor)

      $scope.contributors = contributors

    $scope.currentBudgetId = budget.id
  