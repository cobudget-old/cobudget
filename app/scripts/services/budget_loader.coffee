`// @ngInject`
window.Cobudget.Services.BudgetLoader = ($routeParams, Budget)->

  init: ($rootScope) ->
    @rootScope = $rootScope

  loadFromURL: ->
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

