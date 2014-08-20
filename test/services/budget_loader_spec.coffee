expect = require('../support/expect')
sinon = require('sinon')

require '../support/setup'
require '../../app/scripts/services/budget_loader'

$rootScope = {}

budget_loader = new window.Cobudget.Services.BudgetLoader()
budget_loader.init($rootScope)

describe 'BudgetLoader', ->
  beforeEach ->
    $rootScope.currentBudget = undefined

  #describe 'defaultToFirstBudget', ->
  #  beforeEach ->
  #    $scope.budgets = [{id: 1},{id:7}, {id:3}]

  #  it 'does nothing if scope.budgets empty', ->
  #    $scope.budgets = []
  #    budget_loader.defaultToFirstBudget()
  #    expect($rootScope.currentBudget).to.eq(undefined)

  #  describe 'when scope.currentBudgetId is unset', ->
  #    beforeEach ->
  #      $scope.currentBudgetId = ''
  #      budget_loader.defaultToFirstBudget()

  #    it 'sets rootScope.currentBudget to the first budget', ->
  #      expect($rootScope.currentBudget).to.eq($scope.budgets[0])

  #    it 'sets scope.currentBudgetId to the budget id', ->
  #      expect($scope.currentBudgetId).to.eq(1)

  #  describe 'when scope.currentBudgetId is set', ->
  #    beforeEach ->
  #      $scope.currentBudgetId = 7
  #      budget_loader.defaultToFirstBudget()

  #    it 'does not change the current budgetId', ->
  #      expect($scope.currentBudgetId).to.eq(7)


  describe 'setBudget', ->
    xit 'sets $rootScope.currentBudget if id matches', ->
      budget = {id: 7}
      Budget.myBudgets.returns([{id: 2}, budget, {id: 1}])
      load_controller()
      BudgetLoader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(budget)

    xit 'does nothing if scope array is empty', ->
      Budget.myBudgets.returns([])
      load_controller()
      $rootScope.currentBudget = null
      BudgetLoader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(null)
      
    xit 'does nothing if no budget with id exists', ->
      Budget.myBudgets.returns([{id: 4}, {id: 3}])
      load_controller()
      $rootScope.currentBudget = null
      BudgetLoader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(null)
  describe 'setBudget', ->
    it 'sets rootScope.currentBudget to the first budget with matching id'



