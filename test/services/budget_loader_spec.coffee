expect = require('../support/expect')
sinon = require('sinon')
Restangular = require('../support/restangular-stub')

require '../support/setup'
require '../../app/scripts/services/budget_loader'
require '../../app/scripts/resources/budgets'

$rootScope = {}

describe 'BudgetLoader', ->
  before ->
    global.Budget = {
      allObject: sinon.stub()
      all: ->
        then: (callback) ->
          callback(Budget.allObject())
    }
    global.budget_loader = new window.Cobudget.Services.BudgetLoader({ id: 1 }, Budget)
    global.budget_loader.init($rootScope)

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
    it 'sets rootScope.currentBudget to the first budget with matching id', ->
      budget = {id: 7}
      Budget.allObject.returns([{id: 2}, budget, {id: 1}])
      budget_loader.loadAll()
      budget_loader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(budget)

    it 'does nothing if scope array is empty', ->
      Budget.allObject.returns([])
      budget_loader.loadAll()
      budget_loader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(undefined)
      
    it 'does nothing if no budget with id exists', ->
      Budget.allObject.returns([{id: 4}, {id: 3}])
      budget_loader.loadAll()
      budget_loader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(undefined)