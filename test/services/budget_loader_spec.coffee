expect = require('../support/expect')
sinon = require('sinon')
Restangular = require('../support/restangular-stub')

require '../support/setup'
require '../../app/scripts/services/budget_loader'
require '../../app/scripts/resources/budgets'

describe 'BudgetLoader', ->

  budget_loader = undefined
  $rootScope = undefined

  before ->
    global.Budget = {
      allObject: sinon.stub()
      all: ->
        then: (callback) ->
          callback(Budget.allObject())
    }

  beforeEach ->
    $rootScope = {}
    budget_loader = new window.Cobudget.Services.BudgetLoader({ id: 1 }, Budget)
    budget_loader.init($rootScope)

  describe 'loadAll', ->
    it 'sets rootScope.budgets based on output of Budget.all', ->
      budgets = [{id: 1},{id:7}, {id:3}]
      Budget.allObject.returns(budgets)
      budget_loader.loadAll()
      expect($rootScope.budgets).to.deep.eq(budgets)

  describe 'setBudget', ->
    it 'sets rootScope.currentBudget to the first budget with matching id', ->
      budget = {id: 7}
      $rootScope.budgets = [{id: 2}, budget, {id: 1}]
      budget_loader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(budget)

    it 'does nothing if scope array is empty', ->
      budget_loader.budgets = []
      budget_loader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(undefined)
      
    it 'does nothing if no budget with id exists', ->
      budget_loader.budgets = [{id: 4}, {id: 3}]
      budget_loader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(undefined)

  describe 'defaultToFirstBudget', ->

    it 'sets rootScope.currentBudget to the first budget', ->
      budgets = [{id: 1},{id:7}, {id:3}]
      $rootScope.budgets = budgets
      budget_loader.defaultToFirstBudget()
      expect($rootScope.currentBudget).to.deep.eq(budgets[0])

     it 'does nothing if scope.budgets empty', ->
       $rootScope.budgets = []
       budget_loader.defaultToFirstBudget()
       expect($rootScope.currentBudget).to.eq(undefined)

