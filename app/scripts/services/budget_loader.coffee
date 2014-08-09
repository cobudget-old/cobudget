window.Cobudget.Services.BudgetLoader = ()->
  init: ($scope, $rootScope) ->
    @scope = $scope
    @rootScope = $rootScope

  loadFromRootScope: ->
    @scope.currentBudgetId = ''
    if @rootScope.currentBudget
      @scope.currentBudgetId = @rootScope.currentBudget.id

  defaultToFirstBudget:  ->
    if @scope.currentBudgetId == '' && @scope.budgets.length > 0
      @rootScope.currentBudget = _.first(@scope.budgets)
      @scope.currentBudgetId = @rootScope.currentBudget.id

  setBudget: (id) ->
    budget = _.first(_.where(@scope.budgets, {'id': id}))
    @rootScope.currentBudget = budget if budget
