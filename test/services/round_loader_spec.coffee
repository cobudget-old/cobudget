expect = require('../support/expect')
sinon = require('sinon')
Restangular = require('../support/restangular-stub')

require '../support/setup'
require '../../app/scripts/services/round_loader'
require '../../app/scripts/resources/budgets'

describe 'RoundLoader', ->

  round_loader = undefined
  $rootScope = undefined
  $routeParams = undefined

  before ->
    global.Budget = {
      allObject: sinon.stub()
      all: ->
        then: (callback) ->
          callback(Budget.allObject())
    }

  beforeEach ->
    $rootScope = {}
    $routeParams = {}
    round_loader = new window.Cobudget.Services.RoundLoader($routeParams, Budget)
    round_loader.init($rootScope)

  describe 'loadAll', ->
    it 'sets rootScope.budgets based on output of Budget.all', ->
      budgets = [{id: 1},{id:7}, {id:3}]
      Budget.allObject.returns(budgets)
      round_loader.loadAll()
      expect($rootScope.budgets).to.deep.eq(budgets)

  describe 'setBudget', ->
    it 'sets rootScope.currentBudget to the first budget with matching id', ->
      budget = {id: 7}
      $rootScope.budgets = [{id: 2}, budget, {id: 1}]
      round_loader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(budget)

    it 'does nothing if scope array is empty', ->
      round_loader.budgets = []
      round_loader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(undefined)
      
    it 'does nothing if no budget with id exists', ->
      round_loader.budgets = [{id: 4}, {id: 3}]
      round_loader.setBudget(7)
      expect($rootScope.currentBudget).to.eq(undefined)

  describe 'defaultToFirstBudget', ->

    it 'sets rootScope.currentBudget to the first budget', ->
      budgets = [{id: 1},{id:7}, {id:3}]
      $rootScope.budgets = budgets
      round_loader.defaultToFirstBudget()
      expect($rootScope.currentBudget).to.deep.eq(budgets[0])

     it 'does nothing if scope.budgets empty', ->
       $rootScope.budgets = []
       round_loader.defaultToFirstBudget()
       expect($rootScope.currentBudget).to.eq(undefined)

  describe 'setBudgetByRoute', ->
    it 'sets rootScope.currentBudget to budget id in route', ->
      budget = {id:7}
      $rootScope.budgets = [{id: 1}, budget, {id: 3}]
      $routeParams.budgetId = 7
      round_loader.setBudgetByRoute()
      expect($rootScope.currentBudget).to.eq(budget)

    it 'sets rootScope.currentBudget to first budget if no budget id in route', ->
      budget = { id: 8 }
      $rootScope.budgets = [budget, {id: 2}, {id: 4}]
      round_loader.setBudgetByRoute()
      expect($rootScope.currentBudget).to.eq(budget)


  describe 'initBudget', ->
    describe 'when rootScope.currentBudget is unset', ->

      it 'sets rootScope.currentBudget to budget id in route', ->
        budget = {id:7}
        $rootScope.budgets = [{id: 1}, budget, {id: 3}]
        $routeParams.budgetId = 7
        round_loader.initBudget()
        expect($rootScope.currentBudget).to.eq(budget)

      it 'sets rootScope.currentBudget to first budget if no budget id in route', ->
        budget = { id: 8 }
        $rootScope.budgets = [budget, {id: 2}, {id: 4}]
        round_loader.initBudget()
        expect($rootScope.currentBudget).to.eq($rootScope.budgets[0])

    describe 'when scope.currentBudgetId is set', ->
      beforeEach ->
        $rootScope.currentBudget = { id: 3}

      it 'does not set rootScope.currentBudget to budget id in route', ->
        currentBudget = $rootScope.currentBudget
        $rootScope.budgets = [{id: 1}, { id: 7 }, {id: 3}]
        $routeParams.budgetId = 7
        round_loader.initBudget()
        expect($rootScope.currentBudget).to.eq(currentBudget)

      it 'does not set rootScope.currentBudget to first budget if no budget id in route', ->
        currentBudget = $rootScope.currentBudget
        $rootScope.budgets = [{id: 2}, { id: 5 }, {id: 3}]
        round_loader.initBudget()
        expect($rootScope.currentBudget).to.eq(currentBudget)
