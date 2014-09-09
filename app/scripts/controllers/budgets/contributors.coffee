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
        long_name = contributor.name
        if _.contains(long_name,"'")
          short_name = long_name.substring(0, long_name.indexOf("'"))
          contributor.name = short_name

      $scope.contributors = contributors

    $scope.currentBudgetId = budget.id
  