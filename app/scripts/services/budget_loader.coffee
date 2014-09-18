`// @ngInject`
window.Cobudget.Services.BudgetLoader = ($routeParams, Budget)->

  init: ($rootScope) ->
    @rootScope = $rootScope

  loadAll: ->
    self = @
    Budget.all().then (budgets) ->
        self.rootScope.budgets = budgets

  ###
        #console.log(budgets)
        if $routeParams.budget_id
          $scope.currentBudgetId = parseInt($routeParams.budget_id) 
        else if $rootScope.currentBudget
          $scope.currentBudgetId = $rootScope.currentBudget.id
        else
          $scope.currentBudgetId = budgets[0].id
  ###

  setCurrent: ->
    self = @
    if !@rootScope.currentBudget || @rootScope.currentBudget.id != $routeParams.budget_id
      if $routeParams.budget_id
        Budget.get($routeParams.budget_id).then (budget) ->
          self.setBudget budget

  getBudgetById: (budgets, id) ->
    return _.first(_.where(budgets, {'id': id}))

  getFirstBudget: (budgets) ->
    return _.first(budgets)

  setBudget: (budgetId) ->
    @rootScope.currentBudget = @getBudgetById(@rootScope.budgets, budgetId)

  defaultToFirstBudget: (budget) ->
    @rootScope.currentBudget = @getFirstBudget(@rootScope.budgets)