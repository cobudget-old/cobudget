window.Cobudget.Services.BudgetLoader = ($routeParams, Budget)->

  init: ($scope, $rootScope) ->
    @scope = $scope
    @rootScope = $rootScope

  loadFromURL: ->
    self = @
    if !@rootScope.currentBudget || @rootScope.currentBudget.id != $routeParams.id
      if $routeParams.id
        Budget.get($routeParams.id).then (budget) ->
          self.saveBudget budget

  loadFromRootScope: ->
    @scope.currentBudgetId = ''
    if @rootScope.currentBudget
      @scope.currentBudgetId = @rootScope.currentBudget.id

  defaultToFirstBudget:  ->
    if !@scope.currentBudgetId && @scope.budgets.length > 0
      @rootScope.currentBudget = _.first(@scope.budgets)
      @scope.currentBudgetId = @rootScope.currentBudget.id

  setBudget: (id) ->
    budget = _.first(_.where(@scope.budgets, {'id': id}))
    @saveBudget(budget) if budget

  saveBudget: (budget) ->
    @rootScope.currentBudget = budget
