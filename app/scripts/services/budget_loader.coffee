`// @ngInject`
window.Cobudget.Services.BudgetLoader = ($routeParams, Budget)->

  init: ($rootScope) ->
    @rootScope = $rootScope

  load: ->
    Budget.allBudgets().then (budgets) ->
        $scope.budgets = budgets
        #console.log(budgets)
        if $routeParams.budget_id
          $scope.currentBudgetId = parseInt($routeParams.budget_id) 
        else if $rootScope.currentBudget
          $scope.currentBudgetId = $rootScope.currentBudget.id
        else
          $scope.currentBudgetId = budgets[0].id

  setCurrent: ->
    self = @
    if !@rootScope.currentBudget || @rootScope.currentBudget.id != $routeParams.budget_id
      if $routeParams.budget_id
        Budget.get($routeParams.budget_id).then (budget) ->
          self.setBudget budget

  #turn back on at some stage
  #defaultToFirstBudget:  ->
  #  if !@scope.currentBudgetId && @scope.budgets.length > 0
  #    @rootScope.currentBudget = _.first(@scope.budgets)
  #    @scope.currentBudgetId = @rootScope.currentBudget.id


  setBudgetFromArray: (id, budgets) ->
    budget = _.first(_.where(budgets, {'id': id}))
    @setBudget(budget) if budget


  setBudget: (budget) ->
    @rootScope.currentBudget = budget

